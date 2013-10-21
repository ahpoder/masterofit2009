\c webshoptest1
-- Be adviced that temporary tables are used to ensure that we have the auto generated IDs. In practice these IDs would exist in application and not in temporary tables.
CREATE TEMPORARY TABLE tempidcollection (productid INTEGER NULL, mpricingplanid INTEGER NULL, wpricingplanid INTEGER NULL, ppricingplanid INTEGER NULL, cpricingplanid INTEGER NULL, morderid INTEGER NULL, webshopid INTEGER NULL, customerid INTEGER NULL, corderid INTEGER NULL, ccocid INTEGER NULL, cinvoiceid INTEGER NULL, cdeliveryid INTEGER NULL);
INSERT INTO tempidcollection VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- Create a product
INSERT INTO products (name,weight) VALUES ('XB T-Shirt',156);
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
BEGIN TRANSACTION;
INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES (129.56,0.0,'SideOfShip');
UPDATE tempidcollection SET mpricingplanid=LASTVAL();
-- abLager does not really make sense here, as the websop never directly receive a shipment, so we just choose the minimum one. We could make an NA
INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES (270,0.0,'abLager');
UPDATE tempidcollection SET wpricingplanid=LASTVAL();
INSERT INTO quantitydiscounts SELECT wpricingplanid,10,0.1 FROM tempidcollection;
INSERT INTO quantitydiscounts SELECT wpricingplanid,50,0.2 FROM tempidcollection;
INSERT INTO quantitydiscounts SELECT wpricingplanid,100,0.3 FROM tempidcollection;
INSERT INTO quantitydiscounts SELECT wpricingplanid,500,0.4 FROM tempidcollection;
INSERT INTO quantitydiscounts SELECT wpricingplanid,1000,0.5 FROM tempidcollection;
INSERT INTO pricingplans (price,discount,deliveryconditions) VALUES (599.00,0.0,'7dg');
UPDATE tempidcollection SET ppricingplanid=LASTVAL();
END TRANSACTION;

-- Create a manufactorer product
INSERT INTO manufactorerproducts SELECT 'CN34554345',productid,mpricingplanid FROM tempidcollection;

-- Place order with manufactorer
BEGIN TRANSACTION;
INSERT INTO manufactorerorders (manufactorerid,orderdate) VALUES ('CN34554345',CURRENT_DATE); 
-- This is a trick to the code can be executed in sequence, but in reality it would be an insert with a select of the id followed by another INSERT controlled by the application
UPDATE tempidcollection SET morderid=LASTVAL();
INSERT INTO manufactorerorderedproducts (orderid,productid,priceingplanid,count) SELECT morderid, productid, mpricingplanid, 1200 FROM tempidcollection;
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
UPDATE manufactorerorders SET invoiceid='CPE-INV-00007' WHERE orderid IN (SELECT morderid AS orderid FROM tempidcollection);
END TRANSACTION;

-- After the product is delivered
-- the 1200 from the order products are automatically added to the instock value
BEGIN TRANSACTION;
INSERT INTO manufactorerdeliveries VALUES ('CN34554345', 'DHL-274622', CURRENT_DATE + integer '13');
UPDATE manufactorerorders SET freightno='DHL-274622' WHERE orderid IN (SELECT morderid FROM tempidcollection);
--UPDATE products SET instock=instock+1200 WHERE pid IN (SELECT productid AS pid FROM tempidcollection);
END TRANSACTION;

-- create web-shop
BEGIN TRANSACTION;
INSERT INTO webshops (vatno, name, paymentcurrency, invoiceaddress, paymentconditions) VALUES ('DK12765899','Exciting Webshops Inc.','DKK','Nyhavnsgade 46, 2300 København S','LbMntPlus15dg');
UPDATE tempidcollection SET webshopid=LASTVAL();
END TRANSACTION;

-- Add product to their portfolio
INSERT INTO webshopcarries SELECT webshopid, productid,wpricingplanid,ppricingplanid FROM tempidcollection;

-- Create a customer
BEGIN TRANSACTION;
INSERT INTO customers (webshopid, firstname, middlename, surname, tvmfth, floor, streetletter, streetnumber, streetname, postalcode, region, country) SELECT webshopid, 'Pete', NULL, 'Johanson', NULL, NULL, NULL, 78, 'Bert and Ernie avenue', 6800, NULL, 'Denmark' FROM tempidcollection;
UPDATE tempidcollection SET customerid=LASTVAL();
INSERT INTO customerphones SELECT customerid, '+4512457865' FROM tempidcollection;
INSERT INTO customerattributes SELECT customerid, 'Relation','BrotherInLaw' FROM tempidcollection;
END TRANSACTION;

-- Customer orders a product
BEGIN TRANSACTION;
INSERT INTO customerorders (customerid, orderdate) SELECT customerid, CURRENT_DATE + integer '19' FROM tempidcollection;
UPDATE tempidcollection SET corderid=LASTVAL();
INSERT INTO customerorderproducts SELECT corderid, productid, ppricingplanid, 1 FROM tempidcollection;
-- Here we would calculate the cost of the product and shipping to use in the NETS App
INSERT INTO netspayments VALUES (9877553453, 'LS0gVGhpcyBhbHNvIGRvZXMgbm90IG1hdGNoIHBlcmZlY3RseSB3aXRoIHRoZSBFUiBkaWFncmFtLCBidXQgaXQgaXMgZWFzaWVyIGFzIHdlIGRvIG5vdCBoYXZlIGEgZ3VhcmFudGVlIHRoYXQgdGhlIG9yZGVyaWQgaXMgZ2xvYmFsbHkgdW5pcXVlLg0KQ1JFQVRFIFRBQkxFIGN1c3RvbWVyb3JkZXJjb25maXJtYXRpb25zICgNCmNvY25vIFNFUklBTCBQUklNQVJZIEtFWSwNCmNvY2RhdGUgREFURSBOT1QgTlVMTA0KKTsNCg==');
UPDATE customerorders SET netsid=9877553453 WHERE orderid IN (SELECT corderid FROM tempidcollection);
-- The where is not really needed.
END TRANSACTION;

-- When the order has been approved generate a COC
BEGIN TRANSACTION;
INSERT INTO customerorderconfirmations (cocdate) VALUES (CURRENT_DATE + integer '20');
UPDATE tempidcollection SET ccocid=LASTVAL();
UPDATE customerorders SET cocid=tempidcollection.ccocid FROM customerorders aco INNER JOIN tempidcollection ON aco.orderid=tempidcollection.corderid;
-- WHERE is not needed as there can be only one
END TRANSACTION;

-- When the order has been shipped (NETS payment) or after it has been verified create the invoice
BEGIN TRANSACTION;
INSERT INTO customerinvoices (invoicedate, paybefore) VALUES (CURRENT_DATE + integer '23', CURRENT_DATE + integer '23');
UPDATE tempidcollection SET cinvoiceid=LASTVAL();
UPDATE customerorders SET invoiceid=tempidcollection.cinvoiceid FROM customerorders aco INNER JOIN tempidcollection ON aco.orderid=tempidcollection.corderid;
-- WHERE is not needed as there can be only one
END TRANSACTION;

-- When the order has been shipped
BEGIN TRANSACTION;
INSERT INTO customerdeliveries (deliverydate, freightno) VALUES (CURRENT_DATE + integer '23', 'UPS-2635343');
UPDATE tempidcollection SET cdeliveryid=LASTVAL();
UPDATE customerorders SET deliveryid=tempidcollection.cdeliveryid FROM customerorders aco INNER JOIN tempidcollection ON aco.orderid=tempidcollection.corderid;
-- UPDATE products SET instock=instock-1 WHERE pid IN (SELECT productid AS pid FROM tempidcollection);
UPDATE customerinvoices SET paid=true WHERE invoiceno IN (SELECT cinvoiceid AS invoiceno FROM tempidcollection);
-- WHERE is not needed as there can be only one
END TRANSACTION;

DROP TABLE tempidcollection;