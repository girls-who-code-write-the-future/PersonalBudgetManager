import pyodbc
from datetime import datetime, timedelta
import tkinter as tk
from tkinter import ttk, messagebox

# SQL Server connection configuration
server = 'ZENBOOK-OLGA\\SQLEXPRESS'
database = 'One_person_budget'
connection_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;'

# Define colors
PRIMARY_COLOR = "#d5f5d3"  # Light green
SECONDARY_COLOR = "#c9ebc7"  # Slightly darker green
BUTTON_COLOR = "#a3d4a0"  # Button green
TEXT_COLOR = "#4a734f"  # Darker green for text

def fetch_categories(filter_type=None):
    """Fetches a list of categories from the database."""
    try:
        with pyodbc.connect(connection_string) as conn:
            cursor = conn.cursor()
            if filter_type == "income":
                cursor.execute("SELECT CategoryID, CategoryName FROM Categories WHERE CategoryName IN ('Salary', 'Additional income')")
            elif filter_type == "expense":
                cursor.execute("SELECT CategoryID, CategoryName FROM Categories WHERE CategoryName IN ('Food', 'Transport', 'Bills', 'Entertainment')")
            else:
                cursor.execute("SELECT CategoryID, CategoryName FROM Categories")
            return cursor.fetchall()
    except Exception as e:
        messagebox.showerror("Error", f"Failed to fetch categories: {e}")
        return []

def add_expense(amount, category_id, description):
    """Inserts a new expense into the database."""
    try:
        with pyodbc.connect(connection_string) as conn:
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO Expenses (Amount, CategoryID, Description, Date) VALUES (?, ?, ?, ?)",
                amount, category_id, description, datetime.now()
            )
            conn.commit()
            messagebox.showinfo("Success", "Expense added successfully!")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to add expense: {e}")

def add_income(amount, source, category_id):
    """Inserts a new income into the database."""
    try:
        with pyodbc.connect(connection_string) as conn:
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO Income (Amount, Source, CategoryID, Date) VALUES (?, ?, ?, ?)",
                amount, source, category_id, datetime.now()
            )
            conn.commit()
            messagebox.showinfo("Success", "Income added successfully!")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to add income: {e}")

def add_savings(amount, goal):
    """Inserts a new savings entry into the database."""
    try:
        with pyodbc.connect(connection_string) as conn:
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO Savings (Amount, Goal, Date) VALUES (?, ?, ?)",
                amount, goal, datetime.now()
            )
            conn.commit()
            messagebox.showinfo("Success", "Savings added successfully!")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to add savings: {e}")

def fetch_summary(period, start_date=None, month=None):
    """Fetches the financial summary for the given period."""
    try:
        with pyodbc.connect(connection_string) as conn:
            cursor = conn.cursor()
            current_year = datetime.now().year

            if period == "month":
                if month < datetime.now().month:
                    year = current_year
                else:
                    year = current_year - 1

                date_filter = datetime(year, month, 1)
                next_month = datetime(year, month % 12 + 1, 1) if month < 12 else datetime(year + 1, 1, 1)

                cursor.execute("SELECT SUM(Amount) FROM Income WHERE Date >= ? AND Date < ?", date_filter, next_month)
                total_income = cursor.fetchone()[0] or 0

                cursor.execute("SELECT SUM(Amount) FROM Expenses WHERE Date >= ? AND Date < ?", date_filter, next_month)
                total_expenses = cursor.fetchone()[0] or 0

                cursor.execute("SELECT SUM(Amount) FROM Savings WHERE Date >= ? AND Date < ?", date_filter, next_month)
                total_savings = cursor.fetchone()[0] or 0

            elif period == "week":
                end_date = start_date + timedelta(days=7)
                cursor.execute("SELECT SUM(Amount) FROM Income WHERE Date >= ? AND Date < ?", start_date, end_date)
                total_income = cursor.fetchone()[0] or 0

                cursor.execute("SELECT SUM(Amount) FROM Expenses WHERE Date >= ? AND Date < ?", start_date, end_date)
                total_expenses = cursor.fetchone()[0] or 0

                cursor.execute("SELECT SUM(Amount) FROM Savings WHERE Date >= ? AND Date < ?", start_date, end_date)
                total_savings = cursor.fetchone()[0] or 0

            elif period == "year":
                start_of_year = datetime(start_date, 1, 1)
                start_of_next_year = datetime(start_date + 1, 1, 1)

                cursor.execute("SELECT SUM(Amount) FROM Income WHERE Date >= ? AND Date < ?", start_of_year, start_of_next_year)
                total_income = cursor.fetchone()[0] or 0

                cursor.execute("SELECT SUM(Amount) FROM Expenses WHERE Date >= ? AND Date < ?", start_of_year, start_of_next_year)
                total_expenses = cursor.fetchone()[0] or 0

                cursor.execute("SELECT SUM(Amount) FROM Savings WHERE Date >= ? AND Date < ?", start_of_year, start_of_next_year)
                total_savings = cursor.fetchone()[0] or 0

            return total_income, total_expenses, total_savings
    except Exception as e:
        messagebox.showerror("Error", f"Failed to fetch summary: {e}")
        return None, None, None

def clear_frame(frame):
    """Clears all widgets from a frame."""
    for widget in frame.winfo_children():
        widget.destroy()

def main_menu(root, frame):
    """Creates the main menu of the application."""
    clear_frame(frame)
    frame.configure(bg=PRIMARY_COLOR)

    tk.Label(frame, text="Select an option:", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
    tk.Button(frame, text="Add Expense", command=lambda: add_expense_view(root, frame), font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
    tk.Button(frame, text="Add Income", command=lambda: add_income_view(root, frame), font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
    tk.Button(frame, text="Add Savings", command=lambda: add_savings_view(root, frame), font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
    tk.Button(frame, text="View Balance", command=lambda: view_balance(root, frame), font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
    tk.Button(frame, text="Exit", command=root.destroy, font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=20)

def view_balance(root, frame):
    """Balance view to select the period and show financial summary."""
    clear_frame(frame)
    frame.configure(bg=PRIMARY_COLOR)

    def show_summary(period, **kwargs):
        income, expenses, savings = fetch_summary(period, **kwargs)
        clear_frame(frame)
        frame.configure(bg=PRIMARY_COLOR)

        tk.Label(frame, text=f"Balance for {period.capitalize()}:", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
        tk.Label(frame, text=f"Total Income: {income}", font=("Nunito", 14), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
        tk.Label(frame, text=f"Total Expenses: {expenses}", font=("Nunito", 14), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
        tk.Label(frame, text=f"Total Savings: {savings}", font=("Nunito", 14), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)

        tk.Button(frame, text="Back", command=lambda: view_balance(root, frame), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=20)

    def select_month():
        clear_frame(frame)
        tk.Label(frame, text="Enter the month number you want to check:", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
        month_entry = tk.Entry(frame)
        month_entry.pack(pady=10)

        def submit_month():
            try:
                month = int(month_entry.get())
                if 1 <= month <= 12:
                    show_summary("month", month=month)
                else:
                    messagebox.showerror("Error", "Please enter a valid month (1-12).")
            except ValueError:
                messagebox.showerror("Error", "Please enter a valid number for the month.")

        tk.Button(frame, text="Submit", command=submit_month, font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
        tk.Button(frame, text="Back", command=lambda: view_balance(root, frame), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)

    def select_week():
        clear_frame(frame)
        tk.Label(frame, text="Select Start Date:", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
        tk.Label(frame, text="Enter the start date (YYYY-MM-DD):", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=10)
        start_date_entry = tk.Entry(frame)
        start_date_entry.pack(pady=10)

        def submit_start_date():
            try:
                start_date = datetime.strptime(start_date_entry.get(), "%Y-%m-%d")
                show_summary("week", start_date=start_date)
            except ValueError:
                messagebox.showerror("Error", "Please enter a valid date in YYYY-MM-DD format.")

        tk.Button(frame, text="Submit", command=submit_start_date, font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
        tk.Button(frame, text="Back", command=lambda: view_balance(root, frame), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)

    def select_year():
        clear_frame(frame)
        tk.Label(frame, text="Select Year:", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
        for y in [2023, 2024, 2025]:
            tk.Button(frame, text=str(y), command=lambda y=y: show_summary("year", start_date=y), font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=5)
        tk.Button(frame, text="Back", command=lambda: view_balance(root, frame), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)

    tk.Label(frame, text="Select Period:", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
    tk.Button(frame, text="Week", command=select_week, font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
    tk.Button(frame, text="Month", command=select_month, font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
    tk.Button(frame, text="Year", command=select_year, font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)
    tk.Button(frame, text="Back", command=lambda: main_menu(root, frame), font=("Nunito", 14), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=20)

def add_expense_view(root, frame):
    """Expense addition view."""
    clear_frame(frame)
    frame.configure(bg=PRIMARY_COLOR)

    tk.Label(frame, text="Add Expense", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
    tk.Label(frame, text="Amount:", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
    expense_amount = tk.Entry(frame)
    expense_amount.pack(pady=5)

    tk.Label(frame, text="Category:", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
    categories = fetch_categories("expense")
    category_combobox = ttk.Combobox(frame, values=[c[1] for c in categories])
    category_combobox.pack(pady=5)

    tk.Label(frame, text="Description:", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
    expense_description = tk.Entry(frame)
    expense_description.pack(pady=5)

    tk.Button(frame, text="Add", command=lambda: submit_expense(expense_amount, category_combobox, expense_description, categories), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=20)
    tk.Button(frame, text="Back", command=lambda: main_menu(root, frame), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)

def add_income_view(root, frame):
    """Income addition view."""
    clear_frame(frame)
    frame.configure(bg=PRIMARY_COLOR)

    tk.Label(frame, text="Add Income", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
    tk.Label(frame, text="Amount:", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
    income_amount = tk.Entry(frame)
    income_amount.pack(pady=5)

    tk.Label(frame, text="Category:", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
    categories = fetch_categories("income")
    category_combobox = ttk.Combobox(frame, values=[c[1] for c in categories])
    category_combobox.pack(pady=5)

    tk.Label(frame, text="Source:", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
    income_source = tk.Entry(frame)
    income_source.pack(pady=5)

    tk.Button(frame, text="Add", command=lambda: submit_income(income_amount, income_source, category_combobox, categories), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=20)
    tk.Button(frame, text="Back", command=lambda: main_menu(root, frame), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)

def add_savings_view(root, frame):
    """Savings addition view."""
    clear_frame(frame)
    frame.configure(bg=PRIMARY_COLOR)

    tk.Label(frame, text="Add Savings", font=("Nunito", 18), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
    tk.Label(frame, text="Amount:", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
    savings_amount = tk.Entry(frame)
    savings_amount.pack(pady=5)

    tk.Label(frame, text="Goal (optional):", font=("Nunito", 12), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=5)
    savings_goal = tk.Entry(frame)
    savings_goal.pack(pady=5)

    tk.Button(frame, text="Add", command=lambda: submit_savings(savings_amount, savings_goal), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=20)
    tk.Button(frame, text="Back", command=lambda: main_menu(root, frame), font=("Nunito", 12), bg=BUTTON_COLOR, fg=TEXT_COLOR).pack(pady=10)

def submit_expense(amount_entry, category_combobox, description_entry, categories):
    try:
        amount = float(amount_entry.get())
        category_name = category_combobox.get()
        category_id = next(c[0] for c in categories if c[1] == category_name)
        description = description_entry.get()
        add_expense(amount, category_id, description)
    except ValueError:
        messagebox.showerror("Error", "Please enter valid data.")
    except StopIteration:
        messagebox.showerror("Error", "Please select a valid category.")

def submit_income(amount_entry, source_entry, category_combobox, categories):
    try:
        amount = float(amount_entry.get())
        category_name = category_combobox.get()
        category_id = next(c[0] for c in categories if c[1] == category_name)
        source = source_entry.get()
        add_income(amount, source, category_id)
    except ValueError:
        messagebox.showerror("Error", "Please enter valid data.")
    except StopIteration:
        messagebox.showerror("Error", "Please select a valid category.")

def submit_savings(amount_entry, goal_entry):
    try:
        amount = float(amount_entry.get())
        goal = goal_entry.get() or None
        add_savings(amount, goal)
    except ValueError:
        messagebox.showerror("Error", "Please enter a valid amount.")

# Main Application
if __name__ == "__main__":
    root = tk.Tk()
    root.title("Personal Budget")
    root.geometry("500x600")
    root.configure(bg=PRIMARY_COLOR)

    frame = tk.Frame(root, bg=PRIMARY_COLOR)
    frame.pack(expand=True, fill="both")

    main_menu(root, frame)

    root.mainloop()


