# Archivos para MySQL Workbench

Para cargar la base, seguí este orden:

1. Ejecutá `01_modelo_relacional.sql` para crear la base `churn_pp2` y sus dos tablas.
2. Ejecutá `02_cargar_dim_customer.sql` para cargar los datos básicos de los 7.043 clientes.
3. Ejecutá `03_cargar_fact_subscription_1.sql` y `04_cargar_fact_subscription_2.sql` para cargar las 7.043 suscripciones.
4. Ejecutá `05_consultas.sql` para revisar los conteos y algunos datos.

El archivo `Telco_Customer_Churn.csv` es el CSV original indicado en el script de la cátedra. Los scripts de carga ya tienen los registros acomodados para las tablas. En las 11 filas donde `TotalCharges` venía vacío, guardé 0 porque esos clientes tenían `tenure = 0`. En `churn`, usé 1 para “se fue” y 0 para “se quedó”.

El diagrama `diagrama_entidad_relacion.svg` muestra la relación entre las dos tablas.
