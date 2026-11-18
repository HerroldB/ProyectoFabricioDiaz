-- Ejecuté este archivo después de importar el CSV en stg_telco.
USE churn_db;

-- Primero cargué cada cliente una sola vez.
INSERT IGNORE INTO clientes
    (id_cliente, genero, adulto_mayor, pareja, dependientes)
SELECT
    TRIM(customerID), TRIM(gender), CAST(SeniorCitizen AS UNSIGNED),
    TRIM(Partner), TRIM(Dependents)
FROM stg_telco
WHERE customerID IS NOT NULL AND TRIM(customerID) <> '';

-- Después guardé los servicios y la antigüedad de cada cliente.
-- No escribí id_servicio porque MySQL lo completa con AUTO_INCREMENT.
INSERT IGNORE INTO servicios
    (id_cliente, antiguedad_meses, servicio_telefonico, multiples_lineas,
     servicio_internet, seguridad_online, respaldo_online,
     proteccion_dispositivo, soporte_tecnico, streaming_tv, streaming_peliculas)
SELECT
    TRIM(customerID), tenure, TRIM(PhoneService), TRIM(MultipleLines),
    TRIM(InternetService), TRIM(OnlineSecurity), TRIM(OnlineBackup),
    TRIM(DeviceProtection), TRIM(TechSupport), TRIM(StreamingTV),
    TRIM(StreamingMovies)
FROM stg_telco
WHERE customerID IS NOT NULL AND TRIM(customerID) <> '';

-- Convertí el cargo total a número. Los 11 clientes nuevos tenían el campo vacío,
-- por eso tomé su cargo acumulado como cero cuando tenure también era cero.
INSERT IGNORE INTO facturacion
    (id_cliente, tipo_contrato, facturacion_digital, metodo_pago,
     cargo_mensual, cargo_total)
SELECT
    TRIM(customerID), TRIM(Contract), TRIM(PaperlessBilling),
    TRIM(PaymentMethod), MonthlyCharges,
    CASE
        WHEN TotalCharges IS NULL OR TRIM(TotalCharges) = '' THEN 0.00
        ELSE CAST(TRIM(TotalCharges) AS DECIMAL(10,2))
    END
FROM stg_telco
WHERE customerID IS NOT NULL AND TRIM(customerID) <> '';

-- Por último cargué si cada cliente se fue o siguió.
INSERT IGNORE INTO registro_churn (id_cliente, churn)
SELECT TRIM(customerID), TRIM(Churn)
FROM stg_telco
WHERE customerID IS NOT NULL AND TRIM(customerID) <> '';

-- Revisé la cantidad de filas que quedó en cada tabla.
SELECT 'clientes' AS tabla, COUNT(*) AS filas FROM clientes
UNION ALL
SELECT 'servicios', COUNT(*) FROM servicios
UNION ALL
SELECT 'facturacion', COUNT(*) FROM facturacion
UNION ALL
SELECT 'registro_churn', COUNT(*) FROM registro_churn;
