-- Consultas para comprobar que la carga quedó completa.
USE churn_db;

SELECT 'stg_telco' AS tabla, COUNT(*) AS filas FROM stg_telco
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'servicios', COUNT(*) FROM servicios
UNION ALL SELECT 'facturacion', COUNT(*) FROM facturacion
UNION ALL SELECT 'registro_churn', COUNT(*) FROM registro_churn;

-- Revisé cuántos clientes se fueron y cuántos siguieron.
SELECT churn, COUNT(*) AS cantidad
FROM registro_churn
GROUP BY churn
ORDER BY churn;

-- Estas tres consultas deberían devolver cero si no quedaron relaciones sueltas.
SELECT COUNT(*) AS servicios_sin_cliente
FROM servicios AS s LEFT JOIN clientes AS c ON c.id_cliente = s.id_cliente
WHERE c.id_cliente IS NULL;

SELECT COUNT(*) AS facturas_sin_cliente
FROM facturacion AS f LEFT JOIN clientes AS c ON c.id_cliente = f.id_cliente
WHERE c.id_cliente IS NULL;

SELECT COUNT(*) AS churn_sin_cliente
FROM registro_churn AS r LEFT JOIN clientes AS c ON c.id_cliente = r.id_cliente
WHERE c.id_cliente IS NULL;
