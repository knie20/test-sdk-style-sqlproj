-- Ensure that product stock cannot be negative
ALTER TABLE [Kaidong].[Product]
ADD CONSTRAINT chk_product_stock CHECK (Stock >= 0);
GO
-- Ensure invoice total is non-negative
ALTER TABLE [Kaidong].[Invoice]
ADD CONSTRAINT chk_invoice_total CHECK (TotalAmount >= 0);
GO