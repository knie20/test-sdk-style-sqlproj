-- Stored Procedure to create an invoice
CREATE PROCEDURE CreateInvoice(
    @p_CustomerID INT,
    @p_InvoiceDate DATE,
    @p_InvoiceID INT OUTPUT
)
AS
BEGIN
    INSERT INTO [Kaidong].[Invoice] (CustomerID, InvoiceDate, TotalAmount, Status) 
    VALUES (@p_CustomerID, @p_InvoiceDate, 0, 'Pending');
    SET @p_InvoiceID = LAST_INSERT_ID();
END;
GO

-- Stored Procedure to add an item to an invoice
CREATE PROCEDURE AddInvoiceItem(
    @p_InvoiceID INT,
    @p_ProductID INT,
    @p_Quantity INT
)
AS
BEGIN
    DECLARE @v_PriceAtPurchase DECIMAL(10, 2);

    -- Get product price
    SELECT @v_PriceAtPurchase = Price FROM [Kaidong].[Product] WHERE ProductID = @p_ProductID;

    -- Insert line item
    INSERT INTO [Kaidong].[InvoiceItem] (InvoiceID, ProductID, Quantity, PriceAtPurchase) 
    VALUES (@p_InvoiceID, @p_ProductID, @p_Quantity, @v_PriceAtPurchase);

    -- Update invoice total
    UPDATE [Kaidong].[Invoice] 
    SET TotalAmount = TotalAmount + (@v_PriceAtPurchase * @p_Quantity) 
    WHERE InvoiceID = @p_InvoiceID;
END;
GO
