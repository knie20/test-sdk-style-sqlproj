-- Trigger to update product stock on invoice item insert
CREATE TRIGGER trg_update_stock
ON [Kaidong].[InvoiceItem]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET P.Stock = P.Stock - I.Quantity
    FROM [Kaidong].[Product] P
    INNER JOIN inserted I ON P.ProductID = I.ProductID;
END;

GO