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
pType INTEGER,
inStock INTEGER,
year INTEGER,
productLine INTEGER,
gender CHAR(1),
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
price FLOAT NOT NULL,
PRIMARY KEY (product,manufactorer),
FOREIGN KEY (product) REFERENCES product(pid),
FOREIGN KEY (manufactorer) REFERENCES manufactorer(mid)
);

CREATE TABLE purchases (
pid INTEGER PRIMARY KEY,
purchaseDate DATETIME NOT NULL,
product INTEGER NOT NULL,
manufactorer INTEGER NOT NULL,
purchasePrice FLOAT NOT NULL,
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
product INTEGER NOT NULL
price FLOAT NOT NULL,
PRIMARY KEY (retailer,product),
FOREIGN KEY (retailer) REFERENCES retailer(rid),
FOREIGN KEY (product) REFERENCES product(pid)
);

CREATE TABLE webshop (
wid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL,
);

CREATE TABLE webshopcarries (
webshop INTEGER NOT NULL,
product INTEGER NOT NULL
price FLOAT NOT NULL,
PRIMARY KEY (webshop,product),
FOREIGN KEY (webshop) REFERENCES webshop(wid),
FOREIGN KEY (product) REFERENCES product(pid)
);

CREATE TABLE customer (
cid INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL,
webshop INTEGER NOT NULL,
discount INTEGER NOT NULL DEFAULT 0,
FOREIGN KEY (webshop) REFERENCES webshop(wid)
);

CREATE TABLE customershop (
customer INTEGER PRIMARY KEY,
name VARCHAR(128) NOT NULL,
discount INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE webshopsales (
sid INTEGER PRIMARY KEY,
orderId INTEGER NOT NULL,
customer INTEGER NOT NULL,
salesDate DATETIME NOT NULL,
product INTEGER NOT NULL,
purchasePrice FLOAT NOT NULL,
count INTEGER NOT NULL,
FOREIGN KEY (product) REFERENCES product(pid),
FOREIGN KEY (customer) REFERENCES customer(cid)
);

