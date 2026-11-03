-- PP2 · Clase 4 · DML y transacciones en MySQL Workbench.
-- En churn_pp2, fact_subscription reúne servicios, facturación y churn.
-- Su clave primaria y foránea es customer_id, asignado por dim_customer.
-- Ejecutá cada bloque completo en la misma conexión. Todos cierran con ROLLBACK.
USE churn_pp2;

-- 1. Alta de prueba. Este identificador debe estar libre antes de ejecutar.
START TRANSACTION;

INSERT INTO dim_customer
    (customer_id, gender, senior_citizen, partner, dependents)
VALUES
    ('9999-NEWCL', 'Female', 0, 'Yes', 'No');

INSERT INTO fact_subscription
    (customer_id, contract, monthly_charges, total_charges, churn)
VALUES
    ('9999-NEWCL', 'Month-to-month', 85.50, 85.50, 0);

SELECT
    d.customer_id AS cliente_id,
    d.gender AS genero,
    d.senior_citizen AS adulto_mayor,
    d.partner AS pareja,
    d.dependents AS dependientes,
    f.contract AS tipo_contrato,
    f.monthly_charges AS cargo_mensual,
    f.total_charges AS cargo_total
FROM dim_customer AS d
JOIN fact_subscription AS f ON d.customer_id = f.customer_id
WHERE d.customer_id = '9999-NEWCL';

ROLLBACK;

-- 2. Simular un aumento del 10 % y comprobar que se revierte.
START TRANSACTION;

SELECT 'Antes' AS etapa, customer_id AS cliente_id, monthly_charges AS cargo_mensual
FROM fact_subscription
WHERE customer_id = '7590-VHVEG' AND contract = 'Month-to-month';

-- Workbench suele proteger las actualizaciones que filtran por una columna sin índice.
-- La excepción rige solo para esta sesión y se restaura inmediatamente.
SET @pp2_safe_updates = @@SESSION.sql_safe_updates;
SET SESSION sql_safe_updates = 0;

UPDATE fact_subscription
SET monthly_charges = ROUND(monthly_charges * 1.10, 2)
WHERE contract = 'Month-to-month';

SET SESSION sql_safe_updates = @pp2_safe_updates;

SELECT 'Con aumento' AS etapa, customer_id AS cliente_id, monthly_charges AS cargo_mensual
FROM fact_subscription
WHERE customer_id = '7590-VHVEG' AND contract = 'Month-to-month';

ROLLBACK;

SELECT 'Tras ROLLBACK' AS etapa, customer_id AS cliente_id, monthly_charges AS cargo_mensual
FROM fact_subscription
WHERE customer_id = '7590-VHVEG' AND contract = 'Month-to-month';

-- 3. Validar y simular el borrado de una suscripción con baja.
-- La tabla guarda también los cargos y servicios de esa fila, por eso se revierte.
START TRANSACTION;

SELECT customer_id AS cliente_id, churn AS baja
FROM fact_subscription
WHERE customer_id = '8361-LTMKD' AND churn = 1;

DELETE FROM fact_subscription
WHERE customer_id = '8361-LTMKD' AND churn = 1;

SELECT COUNT(*) AS filas_tras_delete
FROM fact_subscription
WHERE customer_id = '8361-LTMKD' AND churn = 1;

ROLLBACK;

SELECT COUNT(*) AS filas_tras_rollback
FROM fact_subscription
WHERE customer_id = '8361-LTMKD' AND churn = 1;
