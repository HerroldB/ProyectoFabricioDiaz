-- PP2 - Clase 4 - INSERT, UPDATE, DELETE y transacciones.
USE churn_db;

-- Si antes quedó una prueba interrumpida, la limpié antes de empezar.
START TRANSACTION;
DELETE FROM registro_churn WHERE id_cliente = '9999-NEWCL';
DELETE FROM facturacion WHERE id_cliente = '9999-NEWCL';
DELETE FROM servicios WHERE id_cliente = '9999-NEWCL';
DELETE FROM clientes WHERE id_cliente = '9999-NEWCL';
COMMIT;

-- 1. Agregué un cliente de prueba y sus registros relacionados.
INSERT INTO clientes (id_cliente, genero, adulto_mayor, pareja, dependientes)
VALUES ('9999-NEWCL', 'Female', 0, 'Yes', 'No');

-- No indiqué id_servicio: MySQL lo creó con AUTO_INCREMENT.
INSERT INTO servicios (id_cliente, antiguedad_meses, servicio_telefonico)
VALUES ('9999-NEWCL', 0, 'Yes');

INSERT INTO facturacion
    (id_cliente, tipo_contrato, facturacion_digital, metodo_pago,
     cargo_mensual, cargo_total)
VALUES ('9999-NEWCL', 'Month-to-month', 'Yes', 'Electronic check', 85.50, 85.50);

INSERT INTO registro_churn (id_cliente, churn)
VALUES ('9999-NEWCL', 'No');

SELECT c.id_cliente, c.genero, s.id_servicio, f.tipo_contrato,
       f.cargo_mensual, r.churn
FROM clientes AS c
JOIN servicios AS s ON s.id_cliente = c.id_cliente
JOIN facturacion AS f ON f.id_cliente = c.id_cliente
JOIN registro_churn AS r ON r.id_cliente = c.id_cliente
WHERE c.id_cliente = '9999-NEWCL';

-- 2. Aumenté 10% los cargos de contrato mensual para probar UPDATE.
-- Miré antes y después un cliente; luego ROLLBACK devolvió el valor original.
SET @id_facturacion_prueba = (
    SELECT id_facturacion
    FROM facturacion
    WHERE id_cliente = '9999-NEWCL'
);

START TRANSACTION;
SELECT id_cliente, cargo_mensual AS antes
FROM facturacion
WHERE id_facturacion = @id_facturacion_prueba;

UPDATE facturacion
SET cargo_mensual = ROUND(cargo_mensual * 1.10, 2)
WHERE id_facturacion > 0 AND tipo_contrato = 'Month-to-month';

SELECT id_cliente, cargo_mensual AS con_aumento
FROM facturacion
WHERE id_facturacion = @id_facturacion_prueba;
ROLLBACK;

SELECT id_cliente, cargo_mensual AS despues_de_rollback
FROM facturacion
WHERE id_facturacion = @id_facturacion_prueba;

-- 3. Revisé un registro de baja antes de borrarlo.
-- Usé este identificador del CSV y revertí el borrado con ROLLBACK.
START TRANSACTION;
SELECT id_cliente, churn
FROM registro_churn
WHERE id_cliente = '8361-LTMKD' AND churn = 'Yes';

DELETE FROM registro_churn
WHERE id_registro > 0 AND id_cliente = '8361-LTMKD' AND churn = 'Yes';

SELECT COUNT(*) AS filas_despues_del_delete
FROM registro_churn
WHERE id_cliente = '8361-LTMKD';
ROLLBACK;

SELECT COUNT(*) AS filas_despues_del_rollback
FROM registro_churn
WHERE id_cliente = '8361-LTMKD';

-- Borré el cliente de prueba y sus datos para no dejarlo en la base final.
START TRANSACTION;
DELETE FROM registro_churn WHERE id_cliente = '9999-NEWCL';
DELETE FROM facturacion WHERE id_cliente = '9999-NEWCL';
DELETE FROM servicios WHERE id_cliente = '9999-NEWCL';
DELETE FROM clientes WHERE id_cliente = '9999-NEWCL';
COMMIT;
