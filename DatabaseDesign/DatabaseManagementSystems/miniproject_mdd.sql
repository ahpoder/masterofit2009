CREATE DATABASE webshoptest1;
\c webshoptest1

CREATE TYPE productattributetype AS ENUM ('string', 'integer', 'float');

-- weight is in grams so integer is fine.
CREATE TABLE products (
pid SERIAL PRIMARY KEY,
name VARCHAR(128) NOT NULL,
instock INTEGER NOT NULL DEFAULT 0,
weight INTEGER NOT NULL 
);

CREATE TABLE productattributes (
name VARCHAR(128) PRIMARY KEY,
type productattributetype NOT NULL
);

CREATE TABLE productattributerelations (
product INTEGER,
attributename VARCHAR(128),
value VARCHAR(128) NOT NULL,
PRIMARY KEY (product, attributename),
FOREIGN KEY (product) REFERENCES products(pid),
FOREIGN KEY (attributename) REFERENCES productattributes(name)
);

CREATE TYPE termsofdelivery AS ENUM ('abLager', 'SideOfShip', '3month', '14dg', '7dg', '1dg');

CREATE SEQUENCE pricing_plan_seq;

-- if the pricing plans are to be shared it is important that they are immutable (cannot be gauranteed by the DB)
-- serial is a pseudonum for integer/big so it is possible to use an integer to refecerence it in a foreign key.
-- should the pricing plan include a currency??? - or do we default to DKK?
CREATE TABLE pricingplans (
  id SERIAL PRIMARY KEY,
  price FLOAT NOT NULL,
  discount FLOAT NULL,
  deliveryconditions termsofdelivery NULL
);

CREATE TYPE currency AS ENUM ('DKK', 'EUR', 'USD', 'GBP', 'AUD', 'INR', 'AED', 'CAD', 'CHF', 'CNY');

CREATE TABLE manufactorer (
vatno VARCHAR(128) PRIMARY KEY,
name VARCHAR(128) NOT NULL,
paymentcurrency currency NOT NULL
);

CREATE TABLE manufactorerorderconfirmations (
manufactorerid VARCHAR(128),
cocno VARCHAR(128),
cocDate DATE NOT NULL,
PRIMARY KEY(manufactorerid,cocno),
FOREIGN KEY (manufactorerid) REFERENCES manufactorer(vatno)
);

CREATE TABLE manufactorerinvoices (
manufactorerid  VARCHAR(128),
invoiceno VARCHAR(128) NOT NULL,
invoicedate DATE NOT NULL,
paybefore DATE NOT NULL,
paid BOOLEAN NOT NULL DEFAULT false,
PRIMARY KEY(manufactorerid,invoiceno),
FOREIGN KEY (manufactorerid) REFERENCES manufactorer(vatno)
);

CREATE TABLE manufactorerdeliveries (
manufactorerid VARCHAR(128), 
freightno VARCHAR(128),
deliverydate DATE NOT NULL,
PRIMARY KEY(manufactorerid,freightno),
FOREIGN KEY(manufactorerid) REFERENCES manufactorer(vatno)
);

CREATE TABLE manufactorerorders (
orderid SERIAL PRIMARY KEY,
manufactorerid VARCHAR(128),
orderdate DATE NOT NULL,	
cocid VARCHAR(128) NULL,
invoiceid VARCHAR(128) NULL,
freightno VARCHAR(128) NULL,
FOREIGN KEY(manufactorerid) REFERENCES manufactorer(vatno),
FOREIGN KEY(manufactorerid,cocid) REFERENCES manufactorerorderconfirmations(manufactorerid,cocno),
FOREIGN KEY(manufactorerid,invoiceid) REFERENCES manufactorerinvoices(manufactorerid,invoiceno),
FOREIGN KEY(manufactorerid,freightno) REFERENCES manufactorerdeliveries(manufactorerid,freightno)
);

-- Orriginally we had the manufactorercoc, invoice and deliveires reference the order, having order be the single primary key, but this was not possible, As we could not ensure that the cocno and invoiceno would be unique for the manufactorer. Create unique index as no two orders from the same manufactorer may ever have the same cocno - not possible.

-- how do we werify that any product in there for a given manufactorer is also in manufactorerproducts? If manufcatorerid and productid was here it would be possible, but it is not???
CREATE TABLE manufactorerorderedproducts (
orderid INTEGER,
productid INTEGER,
priceingplanid INTEGER NOT NULL,
count INTEGER NOT NULL CHECK (count > 0),
PRIMARY KEY (orderid,productid),
FOREIGN KEY (orderid) REFERENCES manufactorerorders(orderid),
FOREIGN KEY (productid) REFERENCES products(pid),
FOREIGN KEY (priceingplanid) REFERENCES pricingplans(id)
);

CREATE TABLE manufactorerproducts (
manufactorerid VARCHAR(128),
productid INTEGER,
priceingplanid INTEGER NOT NULL,
PRIMARY KEY (manufactorerid,productid),
FOREIGN KEY (manufactorerid) REFERENCES manufactorer(vatno),
FOREIGN KEY (productid) REFERENCES products(pid),
FOREIGN KEY (priceingplanid) REFERENCES pricingplans(id)
);

CREATE TYPE termsofpayment AS ENUM ('prepay', '10dgNet', '14dgNet', '30dgNet', 'LbMntPlus15dg');

CREATE TABLE webshops (
  id SERIAL PRIMARY KEY,
  vatno VARCHAR(64) NOT NULL,
  name VARCHAR(128) NOT NULL,
  paymentcurrency currency NOT NULL,
  invoiceaddress VARCHAR(256) NOT NULL,
  paymentconditions termsofpayment NOT NULL DEFAULT '30dgNet'
);

CREATE TYPE apartmentlocations AS ENUM ('left', 'middle', 'right');
CREATE TYPE countries AS ENUM ('Denmark', 'England', 'USA');

-- We do not store the city as it may be derived form the postal code and there are lots of online services for that, and that way we do not risk an inconsistency.
CREATE TABLE customers (
id SERIAL PRIMARY KEY,
webshopid INTEGER NOT NULL,
firstname VARCHAR(128) NOT NULL,
middlename VARCHAR(128) NULL,
sirname VARCHAR(128) NOT NULL,
tvmfth apartmentlocations NULL,
floor INTEGER NULL,
streetletter CHAR(2) NULL,
streetnumber INTEGER NOT NULL,
streetname VARCHAR(128) NOT NULL,
postalcode VARCHAR(32) NOT NULL,
region VARCHAR(64) NULL,
country countries NOT NULL,
paymentconditions termsofpayment NOT NULL DEFAULT 'prepay',
FOREIGN KEY(webshopid) REFERENCES webshops(id)
);

CREATE TABLE customerphones (
cid INTEGER,
phone VARCHAR(32),
PRIMARY KEY (cid,phone),
FOREIGN KEY (cid) REFERENCES customers(id)
);

CREATE TABLE customerattributes (
  customerid INTEGER,
  name VARCHAR(128),
  value VARCHAR(128) NOT NULL,
  PRIMARY KEY (customerid,name),
  FOREIGN KEY(customerid) REFERENCES customers(id)
);

-- Special customer-specific discount. The functionality is not used at present, and it wil remain empty.
-- This uses a unused primary key and custom unique index trick. This is because the unique-ness of the 
-- columns: customerid,pricingplanid,productid should form the primary key, but as productid may be null 
-- it cannot be part of the primary key, but it can be part of a unique check. However in postgresql 
-- the following is allowed: CREATE TABLE test (t INTEGER NULL, UNIQUE(t)); INSERT INTO test (NULL); INSERT INTO test (NULL);
-- This is because NULL is not nothing, and NULL != NULL (the latter may seem a little counter-intuitive, but it is because NULL 
-- is neither nothing nor something).
-- To bypass this we create two seperate unique indexes depending on whether the productid is NULL or not, and then it works.
CREATE TABLE customerpricingplan (
  id SERIAL PRIMARY KEY,
  customerid INTEGER NOT NULL,
  pricingplanid INTEGER NOT NULL,
  productid INTEGER NULL,
  FOREIGN KEY(customerid) REFERENCES customers(id),
  FOREIGN KEY (productid) REFERENCES products(pid)
);
CREATE UNIQUE INDEX customerpricingplan_3col_uni_idx
ON customerpricingplan (customerid, pricingplanid, productid)
WHERE productid IS NOT NULL;
CREATE UNIQUE INDEX customerpricingplan_2col_uni_idx
ON customerpricingplan (customerid, pricingplanid)
WHERE productid IS NULL;

-- partly for fun and partly because we control the IDs we reverse the dependency and make the ids unique.

CREATE TABLE netspayments (
netsid BIGINT PRIMARY KEY, 
transactionhash VARCHAR(2048)
);

-- This also does not match perfectly with the ER diagram, but it is easier as we do not have a guarantee that the orderid is globally unique.
CREATE TABLE customerorderconfirmations (
cocno SERIAL PRIMARY KEY,
cocdate DATE NOT NULL
);

-- a null in paybefore is used for creditcard payments (immediate)
CREATE TABLE customerinvoices (
invoiceno SERIAL PRIMARY KEY,
invoicedate DATE NOT NULL,
paybefore DATE NULL,
paid BOOLEAN NOT NULL DEFAULT false
);

-- freightno is null is the delivery is picked up at the warehouse
CREATE TABLE customerdeliveries (
deliveryid SERIAL PRIMARY KEY,
deliverydate DATE NOT NULL,
freightno VARCHAR(128) NULL
);

-- the orderid can be left unique only in conjunction with the customer, but that makes the relationship to purchased products more complicated.
CREATE TABLE customerorders (
orderid SERIAL PRIMARY KEY,
customerid INTEGER NOT NULL, 
orderdate DATE NOT NULL,
netsid BIGINT NULL,
cocid INTEGER NULL,
invoiceid INTEGER NULL,
deliveryid INTEGER NULL,
FOREIGN KEY(customerid) REFERENCES customers(id),
FOREIGN KEY(netsid) REFERENCES netspayments(netsid),
FOREIGN KEY(cocid) REFERENCES customerorderconfirmations(cocno),
FOREIGN KEY(invoiceid) REFERENCES customerinvoices(invoiceno),
FOREIGN KEY(deliveryid) REFERENCES customerdeliveries(deliveryid)
);

-- be very very careful. Inserting into this relation will change an existing pricing plan - can it be prevented?
-- At first we have a quantitydiscountrelationships and quantitydiscounts, but we realised that count would never be the same for the same pricing plan so we could save a relation.
-- discount is a percentage
CREATE TABLE quantitydiscounts(
  pricingplanid INTEGER,
  count INTEGER NOT NULL CHECK (count > 0),
  discount FLOAT NOT NULL CHECK (discount > 0 AND discount < 1),
  PRIMARY KEY (pricingplanid, count),
  FOREIGN KEY (pricingplanid) REFERENCES pricingplans(id)
);

CREATE TABLE webshopcarries (
webshopid INTEGER NOT NULL,
productid INTEGER NOT NULL,
wpricingplanid INTEGER NOT NULL,
ppricingplanid INTEGER NOT NULL,
PRIMARY KEY (webshopid,productid),
FOREIGN KEY (webshopid) REFERENCES webshops(id),
FOREIGN KEY (productid) REFERENCES products(pid),
FOREIGN KEY (wpricingplanid) REFERENCES pricingplans(id),
FOREIGN KEY (ppricingplanid) REFERENCES pricingplans(id)
);

CREATE TABLE customerorderproducts (
orderid INTEGER,
productid INTEGER,
priceingplanid INTEGER NOT NULL,
count INTEGER NOT NULL CHECK (count > 0),
PRIMARY KEY (orderid,productid),
FOREIGN KEY (orderid) REFERENCES customerorders(orderid),
FOREIGN KEY (productid) REFERENCES products(pid),
FOREIGN KEY (priceingplanid) REFERENCES pricingplans(id)
);

CREATE FUNCTION trigfunc_manufactorer_order() RETURNS trigger AS $$
  BEGIN
	UPDATE products SET instock=p.instock+mop.count FROM manufactorerorders mo INNER JOIN manufactorerorderedproducts mop ON mo.orderid=mop.orderid INNER JOIN products p ON mop.productid=p.pid WHERE mo.orderid=NEW.orderid;
    return NEW;
  END
$$ LANGUAGE plpgsql;

-- This trigger is only for debugging as we would like to insert an order directly (not via update)
CREATE TRIGGER update_in_stock_manufactorer
  AFTER UPDATE ON manufactorerorders
  FOR EACH ROW 
  WHEN (NEW.freightno IS NOT NULL AND OLD.freightno IS NULL)
  EXECUTE PROCEDURE trigfunc_manufactorer_order();

CREATE FUNCTION trigfunc_customer_order() RETURNS trigger AS $$
  BEGIN
	UPDATE products SET instock=p.instock-cop.count FROM customerorders co INNER JOIN customerorderproducts cop ON co.orderid=cop.orderid INNER JOIN products p ON cop.productid=p.pid WHERE co.orderid=NEW.orderid;
    return NEW;
  END
$$ LANGUAGE plpgsql;

-- This trigger is only for debugging as we would like to insert an order directly (not via update)
CREATE TRIGGER update_in_stock_customer
  AFTER UPDATE ON customerorders
  FOR EACH ROW 
  WHEN (NEW.deliveryid IS NOT NULL AND OLD.deliveryid IS NULL)
  EXECUTE PROCEDURE trigfunc_customer_order();

-- View detailing everything about the customer orders
-- Left join is used as some tables may not contain any entry yet (invlice, delivery) or may never has a matching row (netspayments).
CREATE VIEW customerorderview AS 
SELECT customerid, customerorders.orderid AS orderid, orderdate, cocno, cocdate, invoiceno, invoicedate, paybefore, paid, op.price as amount, customerorders.deliveryid AS deliveryid, deliverydate, freightno, customerorders.netsid AS netsid FROM (SELECT orderid, SUM(price - price*discount/100) price FROM customerorderproducts INNER JOIN pricingplans ON pricingplans.id=customerorderproducts.priceingplanid GROUP BY orderid) op INNER JOIN customerorders ON op.orderid=customerorders.orderid LEFT JOIN customerinvoices ON customerorders.invoiceid=customerinvoices.invoiceno LEFT JOIN customerorderconfirmations ON customerorders.cocid=customerorderconfirmations.cocno LEFT JOIN customerdeliveries ON customerorders.deliveryid=customerdeliveries.deliveryid LEFT JOIN netspayments ON customerorders.netsid=netspayments.netsid;

CREATE VIEW customerorderproductview AS 
SELECT customerid, customerorderview.orderid AS orderid, orderdate, cocno, cocdate, invoiceno, invoicedate, paybefore, paid, amount, deliveryid, deliverydate, freightno, netsid, productid, count, price, discount FROM customerorderview INNER JOIN customerorderproducts ON customerorderview.orderid=customerorderproducts.orderid INNER JOIN pricingplans ON pricingplans.id=customerorderproducts.priceingplanid;
 
CREATE ROLE WebshopRole;
CREATE ROLE CustomerRole;
CREATE ROLE ManufactorerRole;
CREATE ROLE WholesalerRole;

-- The webshops must be able to see its own data, but not change it.
GRANT SELECT ON webshops TO GROUP WebshopRole;
-- The webshops must be able to see which products it carries, and update one of the pricing plans
GRANT SELECT,UPDATE ON webshopcarries TO GROUP WebshopRole;
-- The webshops must be able to create, modify and destroy new customers
GRANT SELECT,INSERT,UPDATE,DELETE ON customers TO GROUP WebshopRole;
GRANT SELECT,INSERT,UPDATE,DELETE ON customerphones TO GROUP WebshopRole;
GRANT SELECT,INSERT,UPDATE,DELETE ON customerattributes TO GROUP WebshopRole;
-- The webshops must be ablet to create customer orders. When the delivery is done and when the money is paid the Wholesaler updates the content.
GRANT SELECT,INSERT ON customerorders TO GROUP WebshopRole;
GRANT SELECT,INSERT ON netspayments TO GROUP WebshopRole;
GRANT SELECT,INSERT ON customerorderproducts TO GROUP WebshopRole;
GRANT SELECT,INSERT ON customerinvoices TO GROUP WebshopRole;
GRANT SELECT,INSERT ON customerorderconfirmations TO GROUP WebshopRole;
GRANT SELECT,INSERT ON customerdeliveries TO GROUP WebshopRole;
GRANT SELECT,INSERT ON pricingplans TO GROUP WebshopRole;
GRANT SELECT,INSERT ON quantitydiscounts TO GROUP WebshopRole;
-- The Webshop mus be able to view the products
GRANT SELECT ON products TO GROUP WebshopRole;
GRANT SELECT ON productattributes TO GROUP WebshopRole;
GRANT SELECT ON productattributerelations TO GROUP WebshopRole;
 
-- The Customer must be able to see its own data but not change it
GRANT SELECT ON customers TO GROUP CustomerRole;
GRANT SELECT ON customerphones TO GROUP CustomerRole;
GRANT SELECT ON customerattributes TO GROUP CustomerRole;
GRANT SELECT ON customerorders TO GROUP CustomerRole;
GRANT SELECT ON netspayments TO GROUP CustomerRole;
GRANT SELECT ON customerorderproducts TO GROUP CustomerRole;
GRANT SELECT ON customerinvoices TO GROUP CustomerRole;
GRANT SELECT ON customerorderconfirmations TO GROUP CustomerRole;
GRANT SELECT ON customerdeliveries TO GROUP CustomerRole;
GRANT SELECT ON pricingplans TO GROUP CustomerRole;
GRANT SELECT ON quantitydiscounts TO GROUP CustomerRole;
GRANT SELECT ON products TO GROUP CustomerRole;
GRANT SELECT ON productattributes TO GROUP CustomerRole;
GRANT SELECT ON productattributerelations TO GROUP CustomerRole;

-- The Manufactorer must be able to see its own data and 
GRANT SELECT ON manufactorer TO GROUP ManufactorerRole;
GRANT SELECT ON manufactorerproducts TO GROUP ManufactorerRole;
GRANT SELECT ON manufactorerorders TO GROUP ManufactorerRole;
GRANT SELECT ON manufactorerorderedproducts TO GROUP ManufactorerRole;
GRANT SELECT,INSERT ON manufactorerorderconfirmations TO GROUP ManufactorerRole;
GRANT SELECT,INSERT ON manufactorerinvoices TO GROUP ManufactorerRole;
GRANT SELECT ON manufactorerdeliveries TO GROUP ManufactorerRole;
GRANT SELECT ON pricingplans TO GROUP ManufactorerRole;
GRANT SELECT ON quantitydiscounts TO GROUP ManufactorerRole;
GRANT SELECT ON products TO GROUP ManufactorerRole;
GRANT SELECT ON productattributes TO GROUP ManufactorerRole;
GRANT SELECT ON productattributerelations TO GROUP ManufactorerRole;

-- The Wholesaler has permission to create and update products
GRANT SELECT,INSERT,UPDATE,DELETE ON products TO GROUP WholesalerRole;
GRANT SELECT,INSERT,UPDATE,DELETE ON productattributes TO GROUP WholesalerRole;
GRANT SELECT,INSERT,UPDATE,DELETE ON productattributerelations TO GROUP WholesalerRole;
-- The wholesaler must be able to the customer delivery and payment status when the product is shipped
GRANT SELECT,UPDATE ON customerdeliveries TO GROUP WholesalerRole;
GRANT SELECT,UPDATE ON customerinvoices TO GROUP WholesalerRole;
-- The Wholesaler should also be able to see the customer
GRANT SELECT ON customers TO GROUP WholesalerRole;
GRANT SELECT ON customerphones TO GROUP WholesalerRole;
GRANT SELECT ON customerattributes TO GROUP WholesalerRole;
GRANT SELECT ON customerorders TO GROUP WholesalerRole;
GRANT SELECT ON netspayments TO GROUP WholesalerRole;
GRANT SELECT ON customerorderproducts TO GROUP WholesalerRole;
GRANT SELECT ON customerorderconfirmations TO GROUP WholesalerRole;
-- The wholesaler can create new pricing plans and remove existing.
GRANT SELECT,INSERT,DELETE ON pricingplans TO GROUP WholesalerRole;
GRANT SELECT,INSERT,DELETE ON quantitydiscounts TO GROUP WholesalerRole;
-- The Wholesaler creates new webshops
GRANT SELECT,INSERT,UPDATE,DELETE ON webshops TO GROUP WholesalerRole;
GRANT SELECT,INSERT,UPDATE,DELETE ON webshopcarries TO GROUP WholesalerRole;
GRANT SELECT,INSERT,UPDATE,DELETE ON manufactorer TO GROUP WholesalerRole;
GRANT SELECT,INSERT,UPDATE,DELETE ON manufactorerproducts TO GROUP WholesalerRole;
GRANT SELECT,INSERT ON manufactorerorders TO GROUP WholesalerRole;
GRANT SELECT,INSERT ON manufactorerorderedproducts TO GROUP WholesalerRole;
GRANT SELECT,INSERT ON manufactorerorderconfirmations TO GROUP WholesalerRole;
GRANT SELECT,INSERT ON manufactorerinvoices TO GROUP WholesalerRole;
GRANT SELECT,INSERT ON manufactorerdeliveries TO GROUP WholesalerRole;

-- A simple way to limit some of what the different people may see, is to use a VIEW. It is then possible to limit what a given user may see to only what the VIEW exposes, and not the actual tables. E.g. the user can only see the pricing plans that relates to webshopcarries, but not the pricing plans which relates only to manufactorerorders

-- Create dummy users
CREATE USER WebShop1 WITH PASSWORD 'ws1' IN ROLE WebshopRole;
CREATE USER WebShop2 WITH PASSWORD 'ws2' IN ROLE WebshopRole;
CREATE USER Manufac1 WITH PASSWORD 'ma1' IN ROLE ManufactorerRole;
CREATE USER Manufac2 WITH PASSWORD 'ma2' IN ROLE ManufactorerRole;
CREATE USER WholeSale1 WITH PASSWORD 'ws1' IN ROLE WholesalerRole;
CREATE USER WholeSale2 WITH PASSWORD 'ws2' IN ROLE WholesalerRole;
