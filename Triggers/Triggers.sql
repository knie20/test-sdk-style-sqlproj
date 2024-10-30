-- Trigger to update product stock on invoice item insert
CREATE TRIGGER trg_update_stock
AFTER INSERT ON InvoiceItem
FOR EACH ROW
BEGIN
    UPDATE Product 
    SET Stock = Stock - NEW.Quantity 
    WHERE ProductID = NEW.ProductID;
END;

-- Trigger to prevent negative stock
CREATE TRIGGER trg_check_stock
BEFORE INSERT ON InvoiceItem
FOR EACH ROW
BEGIN
    DECLARE v_CurrentStock INT;
    SELECT Stock INTO v_CurrentStock FROM Product WHERE ProductID = NEW.ProductID;

    IF v_CurrentStock < NEW.Quantity THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Insufficient stock for product';
    END IF;
END;