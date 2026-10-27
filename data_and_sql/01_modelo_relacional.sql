-- Este archivo crea la estructura relacional en MySQL Workbench.
-- Los registros están en 02_cargar_dim_customer.sql y en los dos archivos 03/04 de fact_subscription.
-- La fuente de datos original es data_and_sql/Telco_Customer_Churn.csv.

CREATE DATABASE IF NOT EXISTS churn_pp2;
USE churn_pp2;

-- Guardé por separado los datos básicos de cada cliente.
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id VARCHAR(20) NOT NULL,
    gender VARCHAR(20),
    senior_citizen TINYINT,
    partner VARCHAR(10),
    dependents VARCHAR(10),
    PRIMARY KEY (customer_id)
);

-- Guardé en esta tabla los servicios, cargos y si el cliente se fue.
CREATE TABLE IF NOT EXISTS fact_subscription (
    customer_id VARCHAR(20) NOT NULL,
    tenure SMALLINT,
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
    monthly_charges DECIMAL(10, 2),
    total_charges DECIMAL(12, 2),
    churn TINYINT,
    PRIMARY KEY (customer_id),
    CONSTRAINT fk_fact_customer
        FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id)
);
