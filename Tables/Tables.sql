-- Customer Table
CREATE TABLE [Kaidong].[Customer] (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Table
CREATE TABLE [Kaidong].[Product] (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    Stock INT NOT NULL DEFAULT 0
);

-- Invoice Table
CREATE TABLE [Kaidong].[Invoice] (
    InvoiceID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    InvoiceDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Paid', 'Cancelled'))
);

-- InvoiceItem Table (Line Items for Invoices)
CREATE TABLE [Kaidong].[InvoiceItem] (
    InvoiceItemID INT PRIMARY KEY,
    InvoiceID INT REFERENCES Invoice(InvoiceID) ON DELETE CASCADE,
    ProductID INT REFERENCES Product(ProductID),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PriceAtPurchase DECIMAL(10, 2) NOT NULL
);