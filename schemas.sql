CREATE TABLE  stores (
    store_id VARCHAR(10) PRIMARY KEY,
    store_name VARCHAR(50) ,
	city VARCHAR(25),
	country VARCHAR(25)
);

-- CREATE TABLE category
DROP TABLE IF EXISTS category;
CREATE TABLE category (
    category_id VARCHAR(10) PRIMARY KEY,
    category_name VARCHAR(20)
);

-- CREATE TABLE products
CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(35),
    category_id VARCHAR(10),
    launch_date DATE,
    price FLOAT,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- CREATE TABLE sales
CREATE TABLE sales (
    sale_id VARCHAR(15) PRIMARY KEY,
    sale_date DATE,
    store_id VARCHAR(10), -- this fk
    product_id VARCHAR(10), -- this fk
    quantity INT,
    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- CREATE TABLE warranty
CREATE TABLE warranty (
    claim_id VARCHAR(10) PRIMARY KEY,
    claim_date DATE,
    sale_id VARCHAR(15),
    repair_status VARCHAR(15),
    CONSTRAINT fk_orders FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
);