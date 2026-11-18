-- Prácticas de consultas con las tablas del proyecto.
USE churn_db;

-- 1. Elegí algunas columnas para revisar los datos del cliente.
SELECT id_cliente AS cliente_id, genero, adulto_mayor
FROM clientes
LIMIT 10;

-- 2. Busqué cargos mensuales superiores a 70.
SELECT id_cliente AS cliente_id, tipo_contrato, cargo_mensual
FROM facturacion
WHERE cargo_mensual > 70.00;

-- 3a. Busqué clientes mensuales con cargo superior a 50.
SELECT id_cliente AS cliente_id, tipo_contrato, cargo_mensual
FROM facturacion
WHERE tipo_contrato = 'Month-to-month' AND cargo_mensual > 50.00;

-- 3b. También agregué quienes pagan con cheque electrónico.
SELECT id_cliente AS cliente_id, tipo_contrato, cargo_mensual, metodo_pago
FROM facturacion
WHERE (tipo_contrato = 'Month-to-month' AND cargo_mensual > 50.00)
   OR metodo_pago = 'Electronic check';

-- 4. Usé LIKE para buscar el texto Electronic y ordené por cargo.
SELECT id_cliente AS cliente_id, metodo_pago, cargo_mensual
FROM facturacion
WHERE metodo_pago LIKE '%Electronic%'
ORDER BY cargo_mensual DESC, id_cliente;

-- 5. Mostré los cinco cargos acumulados más altos.
SELECT id_cliente AS cliente_id, cargo_total
FROM facturacion
ORDER BY cargo_total DESC, id_cliente
LIMIT 5;

-- 6. Conté las bajas por tipo de contrato.
SELECT f.tipo_contrato, COUNT(*) AS clientes_que_se_fueron
FROM facturacion AS f
JOIN registro_churn AS r ON r.id_cliente = f.id_cliente
WHERE r.churn = 'Yes'
GROUP BY f.tipo_contrato
ORDER BY clientes_que_se_fueron DESC;
