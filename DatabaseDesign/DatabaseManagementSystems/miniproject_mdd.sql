DROP DATABASE webshoptest1;
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
paied BOOLEAN NOT NULL DEFAULT false,
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

-- trigger for inserting the products in the warehouse???

CREATE TABLE phones (
pid INTEGER PRIMARY KEY,
phone VARCHAR(32)
);

CREATE TYPE apartmentlocations AS ENUM ('left', 'middle', 'right');
CREATE TYPE countries AS ENUM ('Denmark', 'England', 'USA');
CREATE TYPE termsofpayment AS ENUM ('prepay', '10dgNet', '14dgNet', '30dgNet', 'LbMntPlus15dg');

-- We do not store the city as it may be derived form the postal code and there are lots of online services for that, and that way we do not risk an inconsistency.
CREATE TABLE customers (
id SERIAL PRIMARY KEY,
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
phones INTEGER NULL,
paymentconditions termsofpayment NOT NULL DEFAULT 'prepay',
FOREIGN KEY(phones) REFERENCES phones(pid)
);

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
paied BOOLEAN NOT NULL DEFAULT false
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

CREATE TABLE webshops (
  id SERIAL PRIMARY KEY,
  vatno VARCHAR(64) NOT NULL,
  name VARCHAR(128) NOT NULL,
  paymentcurrency currency NOT NULL,
  invoiceaddress VARCHAR(256) NOT NULL,
  paymentconditions termsofpayment NOT NULL DEFAULT '30dgNet'
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
CREATE TRIGGER insert_in_stock_manufactorer
  AFTER INSERT ON manufactorerorders
  FOR EACH ROW 
  WHEN (NEW.freightno IS NOT NULL)
  EXECUTE PROCEDURE trigfunc_manufactorer_order();

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
CREATE TRIGGER insert_in_stock_customer
  AFTER INSERT ON customerorders
  FOR EACH ROW 
  WHEN (NEW.deliveryid IS NOT NULL)
  EXECUTE PROCEDURE trigfunc_customer_order();

CREATE TRIGGER update_in_stock_customer
  AFTER UPDATE ON customerorders
  FOR EACH ROW 
  WHEN (NEW.deliveryid IS NOT NULL AND OLD.deliveryid IS NULL)
  EXECUTE PROCEDURE trigfunc_customer_order();
