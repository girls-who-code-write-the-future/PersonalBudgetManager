/*
CREATE DATABASE One_person_budget;
GO
USE One_person_budget;
GO

-- Create a table for Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1), -- Auto-increment primary key
    CategoryName VARCHAR(255) NOT NULL -- Name of the category (e.g., Food, Bills, etc.)
);

-- Create a table for Income
CREATE TABLE Income (
    IncomeID INT PRIMARY KEY IDENTITY(1,1), -- Auto-increment primary key
    Date DATE NOT NULL, -- Date of the income
    Amount DECIMAL(10, 2) NOT NULL, -- Income amount
    Source VARCHAR(255), -- Source of the income (e.g., Salary, Freelance)
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID) -- Links to a category in Categories table
);

-- Create a table for Expenses
CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY IDENTITY(1,1), -- Auto-increment primary key
    Date DATE NOT NULL, -- Date of the expense
    Amount DECIMAL(10, 2) NOT NULL, -- Expense amount (positive values)
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID), -- Links to a category in Categories table
    Description VARCHAR(255) -- Short description of the expense
);

-- Create a table for Savings
CREATE TABLE Savings (
    SavingsID INT PRIMARY KEY IDENTITY(1,1), -- Auto-increment primary key
    Date DATE NOT NULL, -- Date of saving
    Amount DECIMAL(10, 2) NOT NULL, -- Amount saved
    Goal VARCHAR(255), -- Saving goal (e.g., Traveling, Emergency fund)
    Achieved BIT NOT NULL DEFAULT 0 -- Indicates whether the goal was achieved (default is 0 - not achieved)
);

-- Create indexes to improve query performance
CREATE INDEX idx_Income_CategoryID ON Income(CategoryID);
CREATE INDEX idx_Expenses_CategoryID ON Expenses(CategoryID);

-- Insert initial data into Categories table
INSERT INTO Categories (CategoryName) VALUES
('Food'), ('Transport'), ('Bills'), ('Entertainment'), ('Savings'), ('Salary'), ('Additional income');

-- Insert data into Income table
INSERT INTO Income (Date, Amount, Source, CategoryID) VALUES
-- Salary
('2024-01-01', 16000, 'Salary Payment', 6), 
('2024-02-01', 16000, 'Salary Payment', 6), 
('2024-03-01', 16000, 'Salary Payment', 6), 
('2024-04-01', 16000, 'Salary Payment', 6),
('2024-05-01', 16000, 'Salary Payment', 6), 
('2024-06-01', 16000, 'Salary Payment', 6),
('2024-07-01', 16000, 'Salary Payment', 6), 
('2024-08-01', 16000, 'Salary Payment', 6), 
('2024-09-01', 16000, 'Salary Payment', 6), 
('2024-10-01', 16000, 'Salary Payment', 6),
('2024-11-01', 16000, 'Salary Payment', 6), 
('2024-12-01', 16000, 'Salary Payment', 6),

-- Additional income 
('2024-01-15', 1200, 'Freelance Project', 7), 
('2024-02-15', 1400, 'Freelance Project', 7),
('2024-03-15', 1000, 'Freelance Project', 7), 
('2024-04-15', 1300, 'Freelance Project', 7), 
('2024-05-15', 900, 'Freelance Project', 7),
('2024-06-15', 1600, 'Freelance Project', 7),
('2024-07-15', 800, 'Freelance Project', 7), 
('2024-08-15', 1500, 'Freelance Project', 7), 
('2024-09-15', 1100, 'Freelance Project', 7), 
('2024-10-15', 900, 'Freelance Project', 7),
('2024-11-15', 1400, 'Freelance Project', 7),
('2024-12-15', 1300, 'Freelance Project', 7);


-- Insert data into Expenses table
INSERT INTO Expenses (Date, Amount, CategoryID, Description) VALUES
-- Expenses for January
('2024-01-05', 500, 1, 'Groceries'),
('2024-01-06', 2300, 3, 'Mortgage'),
('2024-01-08', 50, 4, 'Cinema'),
('2024-01-10', 100, 2, 'Monthly ticket'),
('2024-01-12', 150, 1, 'Restaurant'),
('2024-01-13', 500, 1, 'Groceries'),
('2024-01-20', 200, 3, 'Electricity charge'),
('2024-01-23', 90, 1, 'Restaurant'),

-- Expenses for February
('2024-02-05', 500, 1, 'Groceries'),
('2024-02-06', 2300, 3, 'Mortgage'),
('2024-02-07', 50, 4, 'Cinema'),
('2024-02-10', 850, 3, 'Yearly phone bill'),
('2024-02-10', 100, 2, 'Monthly ticket'),
('2024-02-12', 150, 1, 'Restaurant'),
('2024-02-13', 500, 1, 'Groceries'),
('2024-02-14', 50, 4, 'Cinema'),
('2024-02-20', 200, 3, 'Electricity charge'),
('2024-02-23', 90, 1, 'Restaurant'),

-- Expenses for March
('2024-03-05', 500, 1, 'Groceries'),
('2024-03-06', 2300, 3, 'Mortgage'),
('2024-03-07', 200, 4, 'Date'),
('2024-03-08', 900, 3, 'Car Mechanic Bill'),
('2024-03-10', 100, 2, 'Monthly ticket'),
('2024-03-12', 150, 1, 'Restaurant'),
('2024-03-13', 500, 1, 'Groceries'),
('2024-03-14', 50, 4, 'Cinema'),
('2024-03-16', 80, 1, 'Food Delivery'),
('2024-03-20', 200, 3, 'Electricity charge'),
('2024-03-23', 90, 1, 'Restaurant'),
('2024-03-29', 450, 1, 'Groceries'),

-- Expenses for April
('2024-04-05', 500, 1, 'Groceries'),
('2024-04-06', 2300, 3, 'Mortgage'),
('2024-04-07', 50, 4, 'Cinema'),
('2024-04-10', 500, 3, 'Petrol'),
('2024-04-10', 100, 2, 'Monthly ticket'),
('2024-04-12', 150, 1, 'Restaurant'),
('2024-04-13', 500, 1, 'Groceries'),
('2024-04-13', 350, 3, 'Dentist'),
('2024-04-14', 50, 4, 'Cinema'),
('2024-04-20', 200, 3, 'Electricity charge'),
('2024-04-23', 90, 1, 'Restaurant'),

-- Expenses for May
('2024-05-05', 500, 1, 'Groceries'),
('2024-05-06', 2300, 3, 'Mortgage'),
('2024-05-07', 200, 4, 'Date'),
('2024-05-10', 100, 2, 'Monthly ticket'),
('2024-05-12', 150, 1, 'Restaurant'),
('2024-05-13', 500, 1, 'Groceries'),
('2024-05-14', 50, 4, 'Cinema'),
('2024-05-14', 250, 4, 'Birthday gift'),
('2024-05-16', 80, 1, 'Food Delivery'),
('2024-05-20', 200, 3, 'Electricity charge'),
('2024-05-23', 90, 1, 'Restaurant'),
('2024-05-26', 120, 1, 'Food Delivery'),
('2024-05-29', 450, 1, 'Groceries'),

-- Expenses for June
('2024-06-05', 500, 1, 'Groceries'),
('2024-06-06', 2300, 3, 'Mortgage'),
('2024-06-07', 50, 4, 'Cinema'),
('2024-06-10', 500, 3, 'Petrol'),
('2024-06-10', 100, 2, 'Monthly ticket'),
('2024-06-12', 8000, 5, 'Holidays'),
('2024-06-20', 200, 3, 'Electricity charge'),
('2024-06-23', -90, 1, 'Restaurant'),

-- Expenses for July
('2024-07-05', 500, 1, 'Groceries'),
('2024-07-06', 2300, 3, 'Mortgage'),
('2024-07-07', 50, 4, 'Bar'),
('2024-07-10', 100, 2, 'Monthly ticket'),
('2024-07-12', 150, 1, 'Restaurant'),
('2024-07-13', 500, 1, 'Groceries'),
('2024-07-14', 50, 4, 'Cinema'),
('2024-07-14', 1500, 5, 'Bike'),
('2024-07-16', 80, 1, 'Food Delivery'),
('2024-07-20', 200, 3, 'Electricity charge'),
('2024-07-23', 90, 1, 'Restaurant'),
('2024-07-26', 70, 1, 'Food Delivery'),
('2024-07-29', 360, 1, 'Groceries'),

-- Expenses for August
('2024-08-05', 500, 1, 'Groceries'),
('2024-08-06', 2300, 3, 'Mortgage'),
('2024-08-07', 200, 4, 'Date'),
('2024-08-08', 400, 3, 'Petrol'),
('2024-08-10', 100, 2, 'Monthly ticket'),
('2024-08-12', 150, 1, 'Restaurant'),
('2024-08-13', 500, 1, 'Groceries'),
('2024-08-14', 50, 4, 'Cinema'),
('2024-08-15', 500, 4, 'Teather'),
('2024-08-16', 80, 1, 'Food Delivery'),
('2024-08-20', 200, 3, 'Electricity charge'),
('2024-08-23', 90, 1, 'Restaurant'),
('2024-08-29', 450, 1, 'Groceries'),

-- Expenses for September
('2024-09-05', 500, 1, 'Groceries'),
('2024-09-06', 2300, 3, 'Mortgage'),
('2024-09-07', 200, 4, 'Books'),
('2024-09-10', 100, 2, 'Monthly ticket'),
('2024-09-12', 150, 1, 'Restaurant'),
('2024-09-13', 500, 1, 'Groceries'),
('2024-09-14', 50, 4, 'Cinema'),
('2024-09-14', 250, 4, 'Company Party'),
('2024-09-16', 80, 1, 'Food Delivery'),
('2024-09-20', 450, 3, 'Electricity charge'),
('2024-09-23', 90, 1, 'Restaurant'),
('2024-09-26', 120, 1, 'Food Delivery'),
('2024-09-29', 450, 1, 'Groceries'),
('2024-09-30', 6000, 5, 'Laptop'),

-- Expenses for October
('2024-10-05', 500, 1, 'Groceries'),
('2024-10-06', 2300, 3, 'Mortgage'),
('2024-10-07', 80, 4, 'eBook'),
('2024-10-10', 100, 2, 'Monthly ticket'),
('2024-10-12', 150, 1, 'Restaurant'),
('2024-10-13', 500, 1, 'Groceries'),
('2024-10-14', 50, 4, 'Cinema'),
('2024-10-14', 300, 4, 'Massage'),
('2024-10-16', 120, 1, 'Food Delivery'),
('2024-10-18', 500, 1, 'Groceries'),
('2024-10-20', 450, 3, 'Electricity charge'),
('2024-10-23', 90, 1, 'Restaurant'),
('2024-10-26', 120, 1, 'Food Delivery'),
('2024-10-29', 450, 1, 'Groceries'),

-- Expenses for November
('2024-11-05', 500, 1, 'Groceries'),
('2024-11-06', 2300, 3, 'Mortgage'),
('2024-11-07', 200, 4, 'Date'),
('2024-11-10', 100, 2, 'Monthly ticket'),
('2024-11-12', 150, 1, 'Restaurant'),
('2024-11-13', 500, 1, 'Groceries'),
('2024-11-14', 50, 4, 'Cinema'),
('2024-11-14', 400, 3, 'Wet'),
('2024-11-16', 80, 1, 'Food Delivery'),
('2024-11-20', 200, 3, 'Electricity charge'),
('2024-11-23', 90, 1, 'Restaurant'),
('2024-11-26', 120, 1, 'Food Delivery'),
('2024-11-29', 450, 1, 'Groceries'),

-- Expenses for December 
('2024-12-05', 500, 1, 'Groceries'),
('2024-12-06', 2300, 3, 'Mortgage'),
('2024-12-07', 200, 4, 'Date'),
('2024-12-10', 100, 2, 'Monthly ticket'),
('2024-12-12', 150, 1, 'Restaurant'),
('2024-12-13', 500, 1, 'Groceries'),
('2024-12-14', 2500, 4, 'Ski trip'),
('2024-12-14', 50, 4, 'Cinema'),
('2024-12-16', 80, 1, 'Food Delivery'),
('2024-12-20', 200, 3, 'Electricity charge'),
('2024-12-20', 600, 4, 'Christmas Gifts'),
('2024-12-23', 90, 1, 'Restaurant'),
('2024-12-26', 120, 1, 'Food Delivery'),
('2024-12-29', 450, 1, 'Groceries');


-- Insert data into Savings table
INSERT INTO Savings (Date, Amount, Goal, Achieved) VALUES
-- Savings for January
('2024-01-01', 1000, 'Traveling', 1),
('2024-01-01', 800, 'Emergency fund', 0),
('2024-01-01', 1000, 'New Laptop', 1),
('2024-01-01', 500, 'Pension fund', 1),

-- Savings for February
('2024-02-01', 1000, 'Traveling', 1),
('2024-02-01', 800, 'Emergency fund', 1),
('2024-02-01', 1000, 'New Laptop', 1),
('2024-02-01', 500, 'Pension fund', 1),

-- Savings for March
('2024-03-01', 1000, 'Traveling', 1),
('2024-03-01', 800, 'Emergency fund', 0),
('2024-03-01', 1000, 'New Laptop', 1),
('2024-03-01', 500, 'New Bike', 1),
('2024-03-01', 500, 'Pension fund', 1),

-- Savings for April 
('2024-04-01', 1000, 'Traveling', 1),
('2024-04-01', 800, 'Emergency fund', 1),
('2024-04-01', 1000, 'New Laptop', 1),
('2024-04-01', 500, 'Pension fund', 1),

-- Savings for May
('2024-05-01', 1000, 'Traveling', 1),
('2024-05-01', 800, 'Emergency fund', 1),
('2024-05-01', 1000, 'New Laptop', 1),
('2024-05-01', 500, 'Pension fund', 1),

-- Savings for June
('2024-06-01', 3000, 'Traveling', 1),
('2024-06-01', 800, 'Emergency fund', 0),
('2024-06-01', 1000, 'New Laptop', 0),
('2024-06-01', 500, 'Pension fund', 1),

-- Savings for July
('2024-07-01', 1000, 'Traveling', 0),
('2024-07-01', 800, 'Emergency fund', 1),
('2024-07-01', 1000, 'New Laptop', 0),
('2024-07-01', 1000, 'New Bike', 1),
('2024-07-01', 500, 'Pension fund', 1),

-- Savings for August
('2024-08-01', 1000, 'Traveling', 0),
('2024-08-01', 800, 'Emergency fund', 1),
('2024-08-01', 1000, 'New Laptop', 1),
('2024-08-01', 500, 'Pension fund', 1),

-- Savings for September
('2024-09-01', 1000, 'Traveling', 0),
('2024-09-01', 800, 'Emergency fund', 1),
('2024-09-01', 500, 'Pension fund', 1),

-- Savings for October
('2024-10-01', 1000, 'Traveling', 1),
('2024-10-01', 800, 'Emergency fund', 1),
('2024-10-01', 500, 'Pension fund', 1),

-- Savings for November
('2024-11-01', 1000, 'Traveling', 1),
('2024-11-01', 400, 'Christmas Gifts', 1),
('2024-11-01', 800, 'Emergency fund', 1),
('2024-11-01', 500, 'Pension fund', 1),

-- Savings for December
('2024-12-01', 500, 'Traveling', 1),
('2024-12-01', 400, 'Christmas Gifts', 1),
('2024-12-01', 800, 'Emergency fund', 1),
('2024-12-01', 500, 'Pension fund', 1);
*/

SELECT * FROM Categories;
SELECT * FROM Income;
SELECT * FROM Expenses;
SELECT * FROM Savings;

/*
-- Summary of yearly income
SELECT SUM(Amount) AS TotalIncome FROM Income;



-- Summary of yearly expenses
SELECT SUM(Amount) AS TotalExpenses FROM Expenses;



-- Yearly balance
SELECT 
    (SELECT SUM(Amount) FROM Income) - 
    (SELECT SUM(Amount) FROM Expenses) AS YearlyBalance;



-- Summary of yearly income, expenses and balance by month
SELECT 
    FORMAT(Date, 'yyyy-MM') AS Month, -- Extract the year and month from the date
    SUM(CASE WHEN Amount > 0 THEN Amount ELSE 0 END) AS TotalIncome, -- Sum of positive amounts (Income)
    SUM(CASE WHEN Amount < 0 THEN -Amount ELSE 0 END) AS TotalExpenses, -- Sum of negative amounts (Expenses)
    SUM(CASE WHEN Amount < 0 THEN -Amount ELSE 0 END) AS MonthlyBalance -- Calculate the monthly balance
FROM 
    (SELECT Date, Amount FROM Income
     UNION ALL
     SELECT Date, -Amount FROM Expenses) AS Transactions -- Combine Income and Expenses into a single dataset
GROUP BY FORMAT(Date, 'yyyy-MM') -- Group by year and month
ORDER BY Month; -- Order by month



-- Summary of yearly expenses by category
SELECT 
    c.CategoryName AS Category, -- Category name
    SUM(e.Amount) AS TotalExpenses -- Total expenses for each category
FROM 
    Expenses e
JOIN 
    Categories c ON e.CategoryID = c.CategoryID -- Join to get category names
WHERE 
    YEAR(e.Date) = 2024 -- Filter for the year (e.g., 2024)
GROUP BY 
    c.CategoryName -- Group by category name
ORDER BY 
    TotalExpenses DESC; -- Order by total expenses in descending order
*/