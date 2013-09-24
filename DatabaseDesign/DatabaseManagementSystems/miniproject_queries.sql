-- Be adviced that temporary tables are used to ensure that we have the auto generated IDs. Inpractice these IDs would exist in application and not in temporary tables.

-- Create a product
INSERT INTO product (name,weight) VALUES ("XB T-Shirt",156);
CREATE TEMPORARY TABLE tempproductid (productid INTEGER NOT NULL);
INSERT INTO tempproductid VALUES (LASTVAL());

-- Create a manufactorer
INSERT INTO manufactorer VALUES ('CN34554345','ChinaProductionExcelence','CNY');

-- Create a pricing plan
INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES (129.56,0.0,'abLager');
CREATE TEMPORARY TABLE tempmpricingplanid (ppid INTEGER NOT NULL);
INSERT INTO tempmpricingplanid VALUES (LASTVAL());

-- Create a manufactorer product
INSERT INTO manufactorerproducts VALUES ('CN34554345',SELECT productid FROM tempproductid LIMIT 1,SELECT ppid FROM tempmpricingplanid LIMIT 1);

-- Place order with manufactorer
BEGIN TRANSACTION;
INSERT INTO manufactorerorders (manufactorerid,orderdate) VALUES ('CN34554345',CURRENT_DATE); 
-- This is a trick to the code can be executed in sequence, but in reality it would be an insert with a select of the id followed by another INSERT controlled by the application
CREATE TEMPORARY TABLE temporderid (orderid INTEGER NOT NULL);
INSERT INTO temporderid VALUES (LASTVAL());
INSERT INTO manufactorerorderedproducts (manufactorerid,orderid,productid,priceingplanid,count) VALUES ('CN34554345',SELECT orderid FROM temporderid LIMIT 1,SELECT productid FROM tempproductid LIMIT 1,SELECT priceingplanid FROM manufactorerproducts WHERE manufactorerid='CN34554345' AND productid=(SELECT productid FROM tempproductid LIMIT 1),1200);
END TRANSACTION;

-- After the COC has been received it is verified manually and entered. The order id will be on the COC.
INSERT INTO manufactorerorderconfirmations VALUES ('CN34554345',SELECT orderid FROM temporderid LIMIT 1,'CPE00012');

-- After the invoice is received it is verified manually and entered. The order id will be on the invoice.
-- The payment date may be calculated from the invoice date and the terms of payment, but we will postpone that for now.
INSERT INTO manufactorerinvoices (manufactorerid,orderid,invoiceno,invoicedate,paybefore) VALUES ('CN34554345',SELECT orderid FROM temporderid LIMIT 1,'CPE-INV-00007','2013-10-16','2013-11-16');

-- After the product is delivered
-- The 1200 could be extracted from the manufactorerorderedproducts, but we have chosen to enter it directly, but naturally the delivery was confirmed by looking at manufactorerorderedproducts.
BEGIN TRANSACTION;
INSERT INTO manufactorerdeliveries VALUES ('CN34554345',SELECT orderid FROM temporderid LIMIT 1,'2013-10-30');
UPDATE products SET instock=instock+1200 WHERE pid IN (SELECT productid FROM tempproductid LIMIT 1);
END TRANSACTION;


