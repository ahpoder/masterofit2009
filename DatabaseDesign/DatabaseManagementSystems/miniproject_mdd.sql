CREATE DATABASE test1;
\c test1

CREATE TYPE productattributetype AS ENUM ('string', 'integer', 'float');

-- weight is in grams so integer is fine.
CREATE TABLE product (
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
product INTEGER NOT NULL,
attributename VARCHAR(128) NOT NULL,
value VARCHAR(128) NOT NULL,
PRIMARY KEY (product, attributename),
FOREIGN KEY (product) REFERENCES product(pid),
FOREIGN KEY (attributename) REFERENCES productattributes(name)
);

CREATE TYPE termsofdelivery AS ENUM ('abLager', 'SideOfShop', '3month', '14dg', '7dg', '1dg');

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
FOREIGN KEY manufactorerid REFERENCES manufactorer(vatno)
);

CREATE TABLE manufactorerinvoices (
manufactorerid  VARCHAR(128),
invoiceno VARCHAR(128) NOT NULL,
invoicedate DATE NOT NULL,
paybefore DATE NOT NULL,
paied BOOLEAN NOT NULL DEFAULT false,
PRIMARY KEY(manufactorerid,invoiceno),
FOREIGN KEY manufactorerid REFERENCES manufactorer(vatno)
);

CREATE TABLE manufactorerdeliveries (
manufactorerid VARCHAR(128), 
freightno VARCHAR(128)
deliverydate DATE NOT NULL,
PRIMARY KEY(manufactorerid,freightno),
FOREIGN KEY(manufactorerid) REFERENCES manufactorer(vatno)
);

CREATE TABLE manufactorerorders (
orderid SERIAL PRIMARY KEY,
manufactorerid VARCHAR(128),
orderdate DATE NOT NULL,	
cocid VARCHAR(128) NULL,
invoiceno VARCHAR(128) NULL,
freightno VARCHAR(128) NULL,
FOREIGN KEY(manufactorerid) REFERENCES manufactorer(vatno),
FOREIGN KEY(manufactorerid,cocno) REFERENCES manufactorerorderconfirmations(manufactorerid,cocno),
FOREIGN KEY(manufactorerid,invoiceno) REFERENCES manufactorerorderconfirmations(manufactorerid,invoiceno),
FOREIGN KEY(manufactorerid,freightno) REFERENCES manufactorerorderconfirmations(manufactorerid,freightno)
);

-- Orriginally we had the manufactorercoc, invoice and deliveires reference the order, having order be the single primary key, but this was not possible, As we could not ensure that the cocno and invoiceno would be unique for the manufactorer. Create unique index as no two orders from the same manufactorer may ever have the same cocno - not possible.

CREATE TABLE manufactorerorderedproducts (
orderid INTEGER,
productid INTEGER,
priceingplanid INTEGER NOT NULL,
count INTEGER NOT NULL CHECK (count > 0),
PRIMARY KEY (orderid,productid),
FOREIGN KEY (orderid) REFERENCES manufactorerorders(orderid),
FOREIGN KEY (productid) REFERENCES product(pid),
FOREIGN KEY (priceingplanid) REFERENCES pricingplans(id)
);

CREATE TABLE manufactorerproducts (
manufactorerid VARCHAR(128),
productid INTEGER,
priceingplanid INTEGER NOT NULL,
PRIMARY KEY (manufactorerid,productid),
FOREIGN KEY (manufactorerid) REFERENCES manufactorer(vatno),
FOREIGN KEY (productid) REFERENCES product(pid),
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

CREATE TABLE customers (
id INTEGER PRIMARY KEY,
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
netsid INTEGER PRIMARY KEY, 
transactionhash VARCHAR(2048)
);

-- This also does not match perfectly with the ER diagram, but it is easier as we do not have a guarantee that the orderid is globally unique.
CREATE TABLE customerorderconfirmations (
cocno INTEGER PRIMARY KEY,
cocdate DATE NOT NULL
);

-- a null in paybefore is used for creditcard payments (immediate)
CREATE TABLE customerinvoices (
invoiceno INTEGER PRIMARY KEY,
invoicedate DATE NOT NULL,
paybefore DATE NULL,
paied BOOLEAN NOT NULL DEFAULT false
);

-- freightno is null is the delivery is picked up at the warehouse
CREATE TABLE customerdeliveries (
deliveryid INTEGER PRIMARY KEY,
deliverydate DATE NOT NULL,
freightno VARCHAR(128) NULL
);

-- the orderid can be left unique only in conjunction with the customer, but that makes the relationship to purchased products more complicated.
CREATE TABLE customerorders (
orderid INTEGER PRIMARY KEY,
customerid INTEGER NOT NULL, 
orderdate DATE NOT NULL,
netsid INTEGER NULL,
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
  id INTEGER PRIMARY KEY,
  vatno VARCHAR(64) NOT NULL,
  name VARCHAR(128) NOT NULL,
  paymentcurrency currency NOT NULL,
  invoiceaddress VARCHAR(256) NOT NULL,
  paymentconditions termsofpayment NOT NULL DEFAULT '30dgNet'
);

CREATE TABLE quantitydiscounts (
  id INTEGER PRIMARY KEY,
  count INTEGER NOT NULL CHECK (count > 0),
  discount FLOAT NOT NULL CHECK (discount > 0)
);

-- be very very careful. Inserting into this relation will change an existing pricing plan - can it be prevented?
CREATE TABLE quantitydiscountrelations (
  pricingplanid INTEGER,
  discountid INTEGER,
  PRIMARY KEY (pricingplanid, discountid),
  FOREIGN KEY (pricingplanid) REFERENCES pricingplans(id),
  FOREIGN KEY (discountid) REFERENCES quantitydiscounts(id)
);

CREATE TABLE webshopcarries (
webshopid INTEGER NOT NULL,
productid INTEGER NOT NULL,
wpricingplanid INTEGER NOT NULL,
ppricingplanid INTEGER NOT NULL,
PRIMARY KEY (webshopid,productid),
FOREIGN KEY (webshopid) REFERENCES webshops(id),
FOREIGN KEY (productid) REFERENCES product(pid),
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
FOREIGN KEY (productid) REFERENCES product(pid),
FOREIGN KEY (priceingplanid) REFERENCES pricingplans(id)
);
