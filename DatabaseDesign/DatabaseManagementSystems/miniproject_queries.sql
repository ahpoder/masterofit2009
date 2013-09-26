-- Be adviced that temporary tables are used to ensure that we have the auto generated IDs. Inpractice these IDs would exist in application and not in temporary tables.
CREATE TEMPORARY TABLE tempidcollection (productid INTEGER NULL, mpricingplanid INTEGER NULL, morderid INTEGER NULL);
INSERT INTO tempidcollection VALUES (NULL, NULL, NULL);

-- Create a product
INSERT INTO product (name,weight) VALUES ('XB T-Shirt',156);
UPDATE tempidcollection SET productid=LASTVAL();

-- Create product attribute types
INSERT INTO productattributes VALUES ('productline','string');
INSERT INTO productattributes VALUES ('brand','string');
INSERT INTO productattributes VALUES ('size','string');
INSERT INTO productattributes VALUES ('sizemeasurement','integer');
INSERT INTO productattributes VALUES ('colour','string');

-- Create product attributes
INSERT INTO productattributerelations SELECT productid, 'productline','XB T-shirt' FROM tempidcollection;
INSERT INTO productattributerelations SELECT productid,'brand','XB' FROM tempidcollection;
INSERT INTO productattributerelations SELECT productid,'size','M' FROM tempidcollection;
INSERT INTO productattributerelations SELECT productid,'sizemeasurement',42 FROM tempidcollection;
INSERT INTO productattributerelations SELECT productid,'colour','green' FROM tempidcollection;

-- Create a manufactorer
INSERT INTO manufactorer VALUES ('CN34554345','ChinaProductionExcelence','CNY');

-- Create a pricing plan
INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES (129.56,0.0,'abLager');
UPDATE tempidcollection SET mpricingplanid=LASTVAL();

-- Create a manufactorer product
INSERT INTO manufactorerproducts SELECT 'CN34554345',productid,mpricingplanid FROM tempidcollection;

-- Place order with manufactorer
BEGIN TRANSACTION;
INSERT INTO manufactorerorders (manufactorerid,orderdate) VALUES ('CN34554345',CURRENT_DATE); 
-- This is a trick to the code can be executed in sequence, but in reality it would be an insert with a select of the id followed by another INSERT controlled by the application
UPDATE tempidcollection SET morderid=LASTVAL();
INSERT INTO manufactorerorderedproducts (orderid,productid,priceingplanid,count) SELECT morderid, productid, mpriceingplanid, 1200 FROM tempidcollection;
END TRANSACTION;

-- After the COC has been received it is verified manually and entered. The order id will be on the COC.
BEGIN TRANSACTION;
INSERT INTO manufactorerorderconfirmations VALUES ('CN34554345','CPE00012',CURRENT_DATE + integer '2');
UPDATE manufactorerorders SET cocid='CPE00012' WHERE orderid IN (SELECT morderid FROM tempidcollection);
-- The last where is not really needed
END TRANSACTION;

-- After the invoice is received it is verified manually and entered. The order id will be on the invoice.
-- The payment date may be calculated from the invoice date and the terms of payment, but we will postpone that for now.
BEGIN TRANSACTION;
-- Date format '2013-10-16'
INSERT INTO manufactorerinvoices (manufactorerid,invoiceno,invoicedate,paybefore) VALUES ('CN34554345', 'CPE-INV-00007',CURRENT_DATE + integer '10',CURRENT_DATE + integer '40');
UPDATE manufactorerorders SET invoiceno='CPE-INV-00007' WHERE orderid IN (SELECT morderid FROM tempidcollection);
END TRANSACTION;

-- After the product is delivered
-- The 1200 could be extracted from the manufactorerorderedproducts, but we have chosen to enter it directly, but naturally the delivery was confirmed by looking at manufactorerorderedproducts.
BEGIN TRANSACTION;
INSERT INTO manufactorerdeliveries VALUES ('CN34554345', 'DHL-274622', CURRENT_DATE + integer '13');
UPDATE manufactorerorders SET freightno='DHL-274622' WHERE orderid IN (SELECT morderid FROM tempidcollection);
UPDATE products SET instock=instock+1200 WHERE pid IN (SELECT productid AS pid FROM tempidcollection);
END TRANSACTION;

-- create web-shop

