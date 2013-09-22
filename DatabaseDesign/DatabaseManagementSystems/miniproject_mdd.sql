CREATE DATABASE test1;
\c test1

CREATE TYPE productattributetype AS ENUM ('string', 'integer', 'float');

CREATE TABLE product (
pid INTEGER PRIMARY KEY,
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

CREATE TYPE currency AS ENUM ('DKK', 'EUR', 'USD', 'GBP', 'AUD', 'INR', 'AED', 'CAD', 'CHF', 'CNY');

CREATE TABLE manufactorer (
vatno VARCHAR(128) PRIMARY KEY,
name VARCHAR(128) NOT NULL
paymentcurrency currency NOT NULL,
invoiceaddress VARCHAR(256)
);

-- As we generate the order id we could have it be globally unique, and then have it be the sole primary key. Makes it easier later?
CREATE TABLE manufactorerorders (
manufactorerid VARCHAR(128), 
orderid INTEGER,
orderdate DATETIME NOT NULL,
PRIMARY KEY(manufactorerid,orderid),
FOREIGN KEY(manufactorerid) REFERENCES manufactorer(vatno)
);

-- The manufactorerid and orderid is unique, but so is manufactorerid and cocno (unless the manufactorer restarts the number)
-- This also does not match perfectly with the ER diagram, but it is easier as we do not have a guarantee that the orderid is globally unique.
CREATE TABLE manufactorerorderconfirmations (
manufactorerid VARCHAR(128), 
orderid INTEGER,
cocno VARCHAR(128) NOT NULL,
PRIMARY KEY(manufactorerid,orderid),
UNIQUE (orderid, cocno),
UNIQUE (manufactorerid, cocno),
FOREIGN KEY(manufactorerid) REFERENCES manufactorer(vatno),
FOREIGN KEY(orderid) REFERENCES manufactorerorders(orderid)
);

CREATE TABLE manufactorerinvoices (
manufactorerid VARCHAR(128), 
orderid INTEGER,
invoiceno VARCHAR(128) NOT NULL,
paybefore DATE NOT NULL,
paied BOOLEAN NOT NULL DEFAULT false,
PRIMARY KEY(manufactorerid,orderid),
UNIQUE (orderid, invoiceno),
UNIQUE (manufactorerid, invoiceno),
FOREIGN KEY(manufactorerid) REFERENCES manufactorer(vatno),
FOREIGN KEY(orderid) REFERENCES manufactorerorders(orderid)
);

CREATE TABLE manufactorerdeliveries (
manufactorerid VARCHAR(128), 
orderid INTEGER,
deliverydate DATETIME NOT NULL,
PRIMARY KEY(manufactorerid,orderid),
FOREIGN KEY(manufactorerid) REFERENCES manufactorer(vatno),
FOREIGN KEY(orderid) REFERENCES manufactorerorders(orderid)
);

-- trigger for inserting the products in the warehouse???

CREATE TABLE phones (
pid INTEGER PRIMARY KEY,
phone VARCHAR(32)
);

CREATE TYPE apartmentlocations AS ENUM ('left', 'middle', 'right');
CREATE TYPE countries AS ENUM ('Denmark', 'England', 'USA');

CREATE TABLE customers (
wid INTEGER PRIMARY KEY,
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
FOREIGN KEY(phones) REFERENCES phones(pid)
);

CREATE TABLE webshops (

);




CREATE TABLE retailer (
rid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL
);

CREATE TABLE retailercarries (
retailer INTEGER NOT NULL,
product INTEGER NOT NULL,
price REAL NOT NULL,
PRIMARY KEY (retailer,product),
FOREIGN KEY (retailer) REFERENCES retailer(rid),
FOREIGN KEY (product) REFERENCES product(pid)
);

CREATE TABLE retailersales (
sid INTEGER PRIMARY KEY,
orderId INTEGER NOT NULL,
retailer INTEGER NOT NULL,
salesDate TIMESTAMP NOT NULL,
product INTEGER NOT NULL,
purchasePrice REAL NOT NULL,
count INTEGER NOT NULL,
FOREIGN KEY (product) REFERENCES product(pid),
FOREIGN KEY (retailer) REFERENCES retailer(rid)
);

CREATE TABLE webshop (
wid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL
);

CREATE TABLE webshopcarries (
webshop INTEGER NOT NULL,
product INTEGER NOT NULL,
price REAL NOT NULL,
PRIMARY KEY (webshop,product),
FOREIGN KEY (webshop) REFERENCES webshop(wid),
FOREIGN KEY (product) REFERENCES product(pid)
);

CREATE TABLE customer (
cid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL,
authentication UUID NOT NULL,
webshop INTEGER NOT NULL,
discount INTEGER NOT NULL DEFAULT 0,
FOREIGN KEY (webshop) REFERENCES webshop(wid)
);

CREATE TABLE webshopsales (
sid INTEGER PRIMARY KEY,
orderId INTEGER NOT NULL,
customer INTEGER NOT NULL,
salesDate TIMESTAMP NOT NULL,
product INTEGER NOT NULL,
purchasePrice REAL NOT NULL,
count INTEGER NOT NULL,
FOREIGN KEY (product) REFERENCES product(pid),
FOREIGN KEY (customer) REFERENCES customer(cid)
);

CREATE ROLE RetailerRole;
CREATE ROLE ManufactorerRole;
CREATE ROLE WebshopRole;
CREATE ROLE CustomerRole;
CREATE ROLE Wholesaler;

GRANT SELECT ON webshop TO GROUP WebshopRole;
GRANT SELECT, INSERT ON webshopsales TO GROUP WebshopRole;
GRANT SELECT ON webshopsales TO GROUP CustomerRole;
GRANT SELECT ON product TO GROUP WebshopRole;
GRANT SELECT, INSERT ON webshopcarries TO GROUP WebshopRole;

// Limit to column = GRANT SELECT (col1) ON webshopsales TO GROUP CustomerRole;

GRANT SELECT ON retailer TO GROUP RetailerRole;
GRANT SELECT ON retailersales TO GROUP RetailerRole;

GRANT SELECT, INSERT ON webshopcarries TO GROUP RetailerRole;

// Add triggers

// We are unable to limit the quiry further. How is a good design for limiting the select to a specific where
