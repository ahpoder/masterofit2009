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
