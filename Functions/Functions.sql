-- Function to calculate total invoice amount
CREATE FUNCTION CalculateInvoiceTotal(@p_InvoiceID INT) 
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @v_Total DECIMAL(10, 2);

    -- Calculate the total amount
    SELECT @v_Total = SUM(Quantity * PriceAtPurchase)
    FROM [Kaidong].InvoiceItem 
    WHERE InvoiceID = @p_InvoiceID;

    -- Handle NULL case and return result
    RETURN ISNULL(@v_Total, 0);
END;
GO