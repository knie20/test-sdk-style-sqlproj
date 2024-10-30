-- Function to calculate total invoice amount
CREATE FUNCTION CalculateInvoiceTotal(p_InvoiceID INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_Total DECIMAL(10, 2);
    SELECT SUM(Quantity * PriceAtPurchase) INTO v_Total
    FROM InvoiceItem WHERE InvoiceID = p_InvoiceID;
    RETURN IFNULL(v_Total, 0);
END;
