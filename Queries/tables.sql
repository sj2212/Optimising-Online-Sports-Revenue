
CREATE TABLE finance (
    product_id VARCHAR(50),
    listing_price FLOAT,
    sale_price FLOAT,
    discount FLOAT,
    revenue FLOAT
);

CREATE TABLE info (
	product_name VARCHAR(50),
	product_id VARCHAR(50),
	description VARCHAR(100)
);

CREATE TABLE reviews (
	product_name VARCHAR(50),
	product_id VARCHAR(50),
	rating float
);

CREATE TABLE traffic (
	product_id VARCHAR(50),
	last_visited timestamp
);

CREATE TABLE brands (
	product_id VARCHAR(50),
	brand VARCHAR(100)
);