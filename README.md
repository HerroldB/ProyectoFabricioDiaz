# Sistema predictivo de retención de clientes

En este primer entregable preparé una versión sencilla para practicar cómo reconocer clientes que podrían dejar un servicio (churn). Primero cargué y revisé el dataset Telco Customer Churn; después dejé un notebook para limpiar los datos, probar tres modelos y hacer una cuenta económica de ejemplo. También armé un script SQL con dos tablas para guardar la información.

La cuenta económica es una simulación. El dataset no trae resultados de campañas reales, así que no puedo afirmar que una campaña vaya a evitar una baja.

## Archivos

- `data_and_sql/01_modelo_relacional.sql`: preparé dos tablas para PostgreSQL, una para los datos básicos del cliente y otra para su suscripción.
- `notebooks/01_churn_baseline.ipynb`: dejé el notebook comentado para abrirlo en Google Colab. Al ejecutarlo en orden, descarga el CSV, revisa y limpia los datos, compara Regresión Logística, Random Forest y XGBoost, y calcula las métricas.

## Datos

Usé el archivo Telco Customer Churn, un dataset público de ejemplo de IBM con 7.043 registros y 21 columnas. No lo copié al repositorio: el notebook lo descarga desde el enlace original.

- [Descargar el CSV](https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv)
- [Repositorio original de IBM](https://github.com/IBM/telco-customer-churn-on-icp4d)

## Cómo revisé el SQL en clase

En el Módulo 1 trabajé con PostgreSQL y pgAdmin 4. PostgreSQL es la base de datos; pgAdmin 4 es la interfaz gráfica que permite conectarse, escribir consultas SQL, ejecutarlas y leer los resultados.

Para probar el archivo, abrí una base de práctica en pgAdmin 4, elegí **Tools > Query Tool**, cargué `data_and_sql/01_modelo_relacional.sql` y ejecuté el script. Eso crea las dos tablas. Para ver filas, primero hay que cargar datos; el notebook tiene esa opción, pero queda apagada por defecto.

## Probar el notebook

Abrí `notebooks/01_churn_baseline.ipynb` en Google Colab y ejecuté las celdas en orden. La primera instala las librerías adicionales. Al final, el notebook guarda las predicciones de prueba en `predicciones_para_revision.csv` para poder revisarlas.

La carga en PostgreSQL es opcional. Para probarla, primero ejecuté el script SQL, configuré `DATABASE_URL` como variable de entorno en Colab y cambié `CARGAR_EN_POSTGRES` a `True`. Usé una base de práctica porque la carga reemplaza los datos de estas dos tablas.

## Límite de esta versión

Los valores de costo, meses de permanencia, margen y éxito de campaña son supuestos editables para probar la cuenta. No son datos observados ni una recomendación para clientes reales. Para saber si una campaña funciona harían falta resultados de campañas reales.
