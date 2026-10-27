-- Estas consultas sirven para revisar que las tablas tengan datos.
USE churn_pp2;

-- Primero conté los registros de cada tabla.
SELECT COUNT(*) AS total_clientes FROM dim_customer;
SELECT COUNT(*) AS total_suscripciones FROM fact_subscription;

-- Después revisé cuántos clientes se fueron y cuántos se quedaron.
SELECT
    CASE WHEN churn = 1 THEN 'Se fue' ELSE 'Se quedó' END AS estado_cliente,
    COUNT(*) AS cantidad
FROM fact_subscription
GROUP BY churn;

-- Comparé las bajas según el tipo de contrato.
SELECT contract, churn, COUNT(*) AS cantidad
FROM fact_subscription
GROUP BY contract, churn
ORDER BY contract, churn;

-- Revisé el cargo mensual promedio según el estado del cliente.
SELECT churn, ROUND(AVG(monthly_charges), 2) AS promedio_cargo_mensual
FROM fact_subscription
GROUP BY churn;

-- Probé también la relación entre el género y el estado de churn.
SELECT d.gender, f.churn, COUNT(*) AS cantidad
FROM dim_customer AS d
JOIN fact_subscription AS f ON d.customer_id = f.customer_id
GROUP BY d.gender, f.churn
ORDER BY d.gender, f.churn;
