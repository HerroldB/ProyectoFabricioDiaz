-- PP2 · Clase 3 · Consultas sobre Telco Customer Churn.
-- fact_subscription reúne la facturación y dim_customer contiene los datos del cliente.
USE churn_pp2;

-- 1. Mostrar solo identificador, género e indicador de adulto mayor.
SELECT
    customer_id AS cliente_id,
    gender AS genero_cliente,
    senior_citizen AS adulto_mayor
FROM dim_customer;

-- 2. Buscar clientes con un cargo mensual superior a 70.
SELECT
    customer_id AS cliente_id,
    contract AS tipo_contrato,
    monthly_charges AS cargo_mensual
FROM fact_subscription
WHERE monthly_charges > 70.00;

-- 3a. Combinar contrato mensual con cargo superior a 50.
SELECT
    customer_id AS cliente_id,
    contract AS tipo_contrato,
    monthly_charges AS cargo_mensual
FROM fact_subscription
WHERE contract = 'Month-to-month' AND monthly_charges > 50.00;

-- 3b. Incluir también a quienes pagan con cheque electrónico.
SELECT
    customer_id AS cliente_id,
    contract AS tipo_contrato,
    monthly_charges AS cargo_mensual,
    payment_method AS metodo_pago
FROM fact_subscription
WHERE (contract = 'Month-to-month' AND monthly_charges > 50.00)
   OR payment_method = 'Electronic check';

-- 4. Filtrar medios de pago electrónicos y ordenar por cargo mensual.
SELECT
    customer_id AS cliente_id,
    payment_method AS metodo_pago,
    monthly_charges AS cargo_mensual
FROM fact_subscription
WHERE payment_method LIKE '%Electronic%'
ORDER BY monthly_charges DESC, customer_id;

-- 5. Mostrar los cinco mayores cargos acumulados.
SELECT
    customer_id AS cliente_id,
    total_charges AS cargo_total
FROM fact_subscription
ORDER BY total_charges DESC, customer_id
LIMIT 5;
