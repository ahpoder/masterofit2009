CREATE DATABASE test1;
\c test1

CREATE TABLE producttype (
tid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL
);

CREATE TABLE productline (
plid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL
);

CREATE TABLE product (
pid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL,
pType INTEGER NOT NULL,
inStock INTEGER NOT NULL,
year INTEGER NOT NULL,
productLine INTEGER NOT NULL,
gender CHAR(1) NOT NULL,
listPrice REAL NOT NULL,
FOREIGN KEY (pType) REFERENCES ProductType(tid),
FOREIGN KEY (productLine) REFERENCES ProductLine(plid)
);

CREATE TABLE manufactorer (
mid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL
);

CREATE TABLE production (
product INTEGER NOT NULL,
manufactorer INTEGER NOT NULL,
price REAL NOT NULL,
PRIMARY KEY (product,manufactorer),
FOREIGN KEY (product) REFERENCES product(pid),
FOREIGN KEY (manufactorer) REFERENCES manufactorer(mid)
);

CREATE TABLE purchases (
pid INTEGER PRIMARY KEY,
purchaseDate TIMESTAMP NOT NULL,
product INTEGER NOT NULL,
manufactorer INTEGER NOT NULL,
purchasePrice REAL NOT NULL,
count INTEGER NOT NULL,
FOREIGN KEY (product) REFERENCES product(pid),
FOREIGN KEY (manufactorer) REFERENCES manufactorer(mid)
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
