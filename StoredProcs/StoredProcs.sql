-- Stored Procedure to create an invoice
CREATE PROCEDURE CreateInvoice(
    IN p_CustomerID INT,
    IN p_InvoiceDate DATE,
    OUT p_InvoiceID INT
)
BEGIN
    INSERT INTO Invoice (CustomerID, InvoiceDate, TotalAmount, Status) 
    VALUES (p_CustomerID, p_InvoiceDate, 0, 'Pending');
    SET p_InvoiceID = LAST_INSERT_ID();
END;

-- Stored Procedure to add an item to an invoice
CREATE PROCEDURE AddInvoiceItem(
    IN p_InvoiceID INT,
    IN p_ProductID INT,
    IN p_Quantity INT
)
BEGIN
    DECLARE v_PriceAtPurchase DECIMAL(10, 2);

    -- Get product price
    SELECT Price INTO v_PriceAtPurchase FROM Product WHERE ProductID = p_ProductID;

    -- Insert line item
    INSERT INTO InvoiceItem (InvoiceID, ProductID, Quantity, PriceAtPurchase) 
    VALUES (p_InvoiceID, p_ProductID, p_Quantity, v_PriceAtPurchase);

    -- Update invoice total
    UPDATE Invoice 
    SET TotalAmount = TotalAmount + (v_PriceAtPurchase * p_Quantity) 
    WHERE InvoiceID = p_InvoiceID;
END;
