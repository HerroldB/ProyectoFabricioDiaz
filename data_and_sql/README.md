# Archivos de MySQL Workbench

## Orden de uso

1. Ejecuté `01_modelo_relacional.sql` para crear la base `churn_db`, la tabla temporal `stg_telco` y las cuatro tablas finales.
2. Importé `Telco_Customer_Churn.csv` en `stg_telco` con **Table Data Import Wizard** de MySQL Workbench. Los encabezados del CSV coinciden con las columnas de esa tabla.
3. Ejecuté `02_normalizar_datos.sql` para separar los datos en `clientes`, `servicios`, `facturacion` y `registro_churn`.
4. Ejecuté `05_consultas.sql` para revisar los conteos y las claves foráneas.
5. Ejecuté `consultas_churn.sql` y `clase4_dml_transacciones.sql` para las prácticas de SQL.

Después de importar y normalizar, espero ver 7.043 filas en cada una de las cuatro tablas finales. En `registro_churn` espero 1.869 filas con `Yes` y 5.174 con `No`.

`stg_telco` conserva la importación original. `INSERT IGNORE` evita que una segunda ejecución de la normalización duplique los clientes.
