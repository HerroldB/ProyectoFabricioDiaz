# Sistema predictivo de retención de clientes

En este proyecto trabajé con el dataset Telco Customer Churn. Primero cargué y revisé los datos. Después limpié algunas columnas, comparé tres modelos y preparé las tablas para MySQL. En la segunda parte preparé el cálculo para encontrar qué umbral de probabilidad daría el mayor valor económico esperado para una campaña de retención.

## Archivos

- `data_and_sql/Telco_Customer_Churn.csv`: dejé una copia del CSV original de la cátedra.
- `data_and_sql/01_modelo_relacional.sql`: crea la base y las tablas en MySQL.
- `data_and_sql/02_cargar_dim_customer.sql`: carga los datos de los clientes.
- `data_and_sql/03_cargar_fact_subscription_1.sql` y `04_cargar_fact_subscription_2.sql`: cargan las suscripciones, servicios, cargos y bajas.
- `data_and_sql/05_consultas.sql`: consultas para revisar los datos.
- `data_and_sql/diagrama_entidad_relacion.svg`: diagrama de las tablas.
- notebooks/01_churn_baseline.ipynb: descarga y limpia los datos, compara los modelos y guarda las probabilidades.
- notebooks/02_decision_financiera.ipynb: usa esas probabilidades para calcular el umbral y el resultado económico esperado.

## Cómo lo ejecuté

### 1. Cómo cargar la base en MySQL Workbench

1. Conectate a tu servidor desde MySQL Workbench.
2. Abrí y ejecutá `data_and_sql/01_modelo_relacional.sql` para crear la base y las tablas.
3. Ejecutá `data_and_sql/02_cargar_dim_customer.sql`.
4. Ejecutá `data_and_sql/03_cargar_fact_subscription_1.sql` y después `data_and_sql/04_cargar_fact_subscription_2.sql`.
5. Ejecutá `data_and_sql/05_consultas.sql` para revisar los conteos y algunos datos.

El archivo 01 crea la estructura. El archivo 02 carga los 7.043 clientes; los archivos 03 y 04 cargan las 7.043 suscripciones en dos partes. La celda `CARGAR_EN_MYSQL = False` del notebook deja apagada la conexión desde Colab, así que ejecutar el notebook por sí solo no llena MySQL Workbench.

### 2. Preparé los datos y comparé los modelos en Google Colab

1. Abrí notebooks/01_churn_baseline.ipynb en Google Colab.
2. Ejecuté las celdas en orden.
3. El notebook descargó el CSV indicado en el material de la profesora, limpió los valores vacíos, comparó los modelos y guardó predicciones_para_revision.csv.
4. Descargué ese CSV desde el panel de archivos de Colab.

Para comparar usé Regresión Logística, Random Forest y XGBoost. Los comparé con las mismas particiones y elegí el que tuvo mayor ROC AUC en validación. Después revisé sus métricas en el conjunto de prueba.

### 3. Calculé el umbral económico en Google Colab

1. Abrí notebooks/02_decision_financiera.ipynb.
2. Subí predicciones_para_revision.csv cuando Colab lo pidió.
3. Ejecuté las celdas en orden.
4. El notebook buscó el umbral que daba el mayor valor neto esperado en validación y aplicó ese umbral al conjunto de prueba.

La cuenta es una simulación. La consigna y el CSV no incluyen el costo real de una campaña, el margen de la empresa ni la probabilidad de éxito. Para que el código pudiera mostrar cómo funciona, dejé valores de ejemplo editables: costo 20, seis meses, margen 40 % y éxito de campaña 30 %. No son valores informados por la profesora ni resultados reales. Los puedo cambiar cuando tenga datos del negocio.

### 4. Carga con SQLAlchemy

El notebook 01 deja la carga a MySQL apagada por defecto. Para usarla, primero ejecuté el SQL en Workbench y después configuré el host, usuario y contraseña del servidor en Python. La carga usa SQLAlchemy y PyMySQL.

Google Colab se ejecuta en otro equipo, así que no puede conectarse al localhost de mi computadora. Para cargar desde Colab necesito un servidor MySQL al que Colab pueda llegar. Si solo tengo MySQL instalado en mi computadora, puedo ejecutar esa celda desde Python en la misma computadora.

## Dataset

El CSV tiene 7.043 filas y 21 columnas. Lo descargué desde el enlace que usa el script de la profesora:

https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv

## Diccionario de datos

| Columna | Qué representa |
|---|---|
| customerID | Identificador del cliente. |
| gender | Género informado. |
| SeniorCitizen | Indicador 0/1 de adulto mayor. |
| Partner | Si tiene pareja. |
| Dependents | Si tiene personas dependientes. |
| tenure | Antigüedad en meses. |
| PhoneService | Si tiene servicio telefónico. |
| MultipleLines | Si tiene varias líneas o si no corresponde. |
| InternetService | Tipo de servicio de internet. |
| OnlineSecurity | Si tiene seguridad en línea o si no corresponde. |
| OnlineBackup | Si tiene respaldo en línea o si no corresponde. |
| DeviceProtection | Si tiene protección de dispositivo o si no corresponde. |
| TechSupport | Si tiene soporte técnico o si no corresponde. |
| StreamingTV | Si tiene streaming de TV o si no corresponde. |
| StreamingMovies | Si tiene streaming de películas o si no corresponde. |
| Contract | Tipo de contrato. |
| PaperlessBilling | Si usa facturación digital. |
| PaymentMethod | Medio de pago. |
| MonthlyCharges | Cargo mensual. |
| TotalCharges | Cargos acumulados. Algunas filas vienen vacías. |
| Churn | Si dejó el servicio: Yes o No. Fue la variable que intenté predecir. |

## Matriz de decisión

La decisión que analicé fue si convenía ofrecer una campaña de retención.

| Decisión | El cliente se fue | El cliente se quedó |
|---|---|---|
| Contactarlo | La campaña podría conservar parte del margen si logra retenerlo; se resta el costo de contactar. | Se paga la campaña aunque el cliente se hubiera quedado. |
| No contactarlo | No se paga la campaña y se puede perder el margen futuro. | No se paga la campaña. |

Para cada cliente calculé el valor esperado de contactar así:

probabilidad de churn × probabilidad de éxito × margen futuro estimado − costo de campaña

Probé distintos umbrales con los datos de validación y elegí el que dio el mayor valor neto esperado. Después usé ese umbral en el grupo de prueba. El resultado es una simulación, porque no tengo resultados observados de campañas reales. El notebook muestra el umbral, cuántos clientes contactaría, el valor esperado y un ROI simulado al ejecutarlo.
