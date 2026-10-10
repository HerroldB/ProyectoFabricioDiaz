-- Armé estas tablas para practicar con el dataset Telco Customer Churn.
-- Las preparé para PostgreSQL; en clase usamos pgAdmin 4 para ejecutar y leer SQL.

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id VARCHAR(30) PRIMARY KEY,
    gender VARCHAR(20),
    senior_citizen SMALLINT,
    partner VARCHAR(10),
    dependents VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS fact_subscription (
    customer_id VARCHAR(30) PRIMARY KEY,
    tenure INTEGER,
    phone_service VARCHAR(30),
    multiple_lines VARCHAR(40),
    internet_service VARCHAR(40),
    online_security VARCHAR(40),
    online_backup VARCHAR(40),
    device_protection VARCHAR(40),
    tech_support VARCHAR(40),
    streaming_tv VARCHAR(40),
    streaming_movies VARCHAR(40),
    contract VARCHAR(40),
    paperless_billing VARCHAR(10),
    payment_method VARCHAR(60),
    monthly_charges NUMERIC(10, 2),
    total_charges NUMERIC(12, 2),
    churn SMALLINT CHECK (churn IN (0, 1)),
    CONSTRAINT fk_fact_customer
        FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id)
);
