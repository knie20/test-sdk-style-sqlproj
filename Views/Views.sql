-- View to see invoices with customer details
CREATE VIEW InvoiceSummary AS
SELECT 
    I.InvoiceID, I.InvoiceDate, I.TotalAmount, I.Status, 
    C.Name AS CustomerName, C.Email AS CustomerEmail
FROM 
    Invoice I
JOIN 
    Customer C ON I.CustomerID = C.CustomerID;