-- Index for fast search on Customer Email
CREATE INDEX idx_customer_email ON [Kaidong].Customer(Email);
GO
-- Index for Invoice Status to optimize status queries
CREATE INDEX idx_invoice_status ON [Kaidong].Invoice(Status);
GO