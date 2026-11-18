-- Primero creé la base y las tablas en MySQL Workbench.
CREATE DATABASE IF NOT EXISTS churn_db;
USE churn_db;

-- Usé esta tabla temporal para importar el CSV original.
-- Los nombres de las columnas coinciden con los encabezados del archivo.
CREATE TABLE IF NOT EXISTS stg_telco (
    customerID VARCHAR(20),
    gender VARCHAR(10),
    SeniorCitizen TINYINT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure SMALLINT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges VARCHAR(20),
    Churn VARCHAR(5)
);

-- Separé los datos personales de cada cliente.
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente VARCHAR(20) NOT NULL,
    genero VARCHAR(10),
    adulto_mayor TINYINT NOT NULL DEFAULT 0,
    pareja VARCHAR(5),
    dependientes VARCHAR(5),
    PRIMARY KEY (id_cliente)
);

-- Dejé los servicios en otra tabla y asigné el id_servicio con AUTO_INCREMENT.
CREATE TABLE IF NOT EXISTS servicios (
    id_servicio INT NOT NULL AUTO_INCREMENT,
    id_cliente VARCHAR(20) NOT NULL,
    antiguedad_meses SMALLINT,
    servicio_telefonico VARCHAR(10),
    multiples_lineas VARCHAR(30),
    servicio_internet VARCHAR(20),
    seguridad_online VARCHAR(30),
    respaldo_online VARCHAR(30),
    proteccion_dispositivo VARCHAR(30),
    soporte_tecnico VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_peliculas VARCHAR(30),
    PRIMARY KEY (id_servicio),
    UNIQUE (id_cliente),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Separé el contrato, la forma de pago y los cargos.
CREATE TABLE IF NOT EXISTS facturacion (
    id_facturacion INT NOT NULL AUTO_INCREMENT,
    id_cliente VARCHAR(20) NOT NULL,
    tipo_contrato VARCHAR(30),
    facturacion_digital VARCHAR(10),
    metodo_pago VARCHAR(50),
    cargo_mensual DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    cargo_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (id_facturacion),
    UNIQUE (id_cliente),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Guardé el resultado de churn en su propia tabla.
CREATE TABLE IF NOT EXISTS registro_churn (
    id_registro INT NOT NULL AUTO_INCREMENT,
    id_cliente VARCHAR(20) NOT NULL,
    churn VARCHAR(5) NOT NULL,
    PRIMARY KEY (id_registro),
    UNIQUE (id_cliente),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
