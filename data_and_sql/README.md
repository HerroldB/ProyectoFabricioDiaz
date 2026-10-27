# Archivos para MySQL Workbench

Primero ejecuté `01_modelo_relacional.sql` para crear la base `churn_pp2` y sus dos tablas.

Después cargué los registros en este orden:

1. `02_cargar_dim_customer.sql`: datos básicos de los 7.043 clientes.
2. `03_cargar_fact_subscription_1.sql`: primera parte de las suscripciones.
3. `04_cargar_fact_subscription_2.sql`: segunda parte de las suscripciones.
4. `05_consultas.sql`: consultas para revisar los datos.

El archivo `Telco_Customer_Churn.csv` es la copia original que descargué desde el enlace del script de la cátedra. Los scripts de carga contienen los registros ya acomodados para las tablas. En las 11 filas donde `TotalCharges` venía vacío, guardé 0 porque esos clientes tenían `tenure = 0`. En `churn`, usé 1 para “se fue” y 0 para “se quedó”.

El diagrama `diagrama_entidad_relacion.svg` muestra la relación entre las dos tablas.
