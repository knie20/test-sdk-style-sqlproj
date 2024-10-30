-- Ensure that product stock cannot be negative
ALTER TABLE Product
ADD CONSTRAINT chk_product_stock CHECK (Stock >= 0);

-- Ensure invoice total is non-negative
ALTER TABLE Invoice
ADD CONSTRAINT chk_invoice_total CHECK (TotalAmount >= 0);