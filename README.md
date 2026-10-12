# Sistema predictivo de retención de clientes

En este primer entregable preparé una versión para practicar cómo estimar qué clientes podrían dejar un servicio (churn). Cargué y revisé el dataset Telco Customer Churn, dejé un notebook con pasos de limpieza y comparación de tres modelos, y armé un script SQL con dos tablas para PostgreSQL.

La parte económica es inicial. El dataset no trae resultados de campañas reales, así que sus cifras sirven para probar la cuenta y no para afirmar que una campaña vaya a evitar una baja.

## Archivos y ejecución

- `data_and_sql/01_modelo_relacional.sql`: preparé las tablas `dim_customer` y `fact_subscription`.
- `notebooks/01_churn_baseline.ipynb`: organicé el trabajo en secciones numeradas y comenté los pasos. Lo dejé preparado para Google Colab.

Para correr el notebook, abrí el archivo en Google Colab y ejecuté las celdas en orden. Descarga el CSV de IBM, revisa y limpia las filas, entrena Regresión Logística, Random Forest y XGBoost, y guarda las predicciones en `predicciones_para_revision.csv`.

Para revisar el SQL, en el Módulo 1 trabajé con PostgreSQL y pgAdmin 4. En pgAdmin 4 se puede abrir **Tools > Query Tool**, ejecutar el script y leer los resultados. El script crea las tablas vacías; para ver filas primero hay que cargar datos. La carga desde el notebook es opcional y queda apagada por defecto.

## Dataset

Usé Telco Customer Churn, un dataset público de ejemplo de IBM con 7.043 filas y 21 columnas. El notebook lo descarga desde el enlace original; no guardé una copia del CSV en este repositorio.

- [CSV de IBM](https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv)
- [Repositorio original](https://github.com/IBM/telco-customer-churn-on-icp4d)

## Diccionario de datos

| Columna | Qué representa |
|---|---|
| `customerID` | Identificador del cliente. |
| `gender` | Género informado. |
| `SeniorCitizen` | Indicador 0/1 de adulto mayor. |
| `Partner` | Si tiene pareja. |
| `Dependents` | Si tiene personas dependientes. |
| `tenure` | Antigüedad en meses. |
| `PhoneService` | Si tiene servicio telefónico. |
| `MultipleLines` | Si tiene varias líneas o si no corresponde. |
| `InternetService` | Tipo de servicio de internet. |
| `OnlineSecurity` | Si tiene seguridad en línea o si no corresponde. |
| `OnlineBackup` | Si tiene respaldo en línea o si no corresponde. |
| `DeviceProtection` | Si tiene protección de dispositivo o si no corresponde. |
| `TechSupport` | Si tiene soporte técnico o si no corresponde. |
| `StreamingTV` | Si tiene streaming de TV o si no corresponde. |
| `StreamingMovies` | Si tiene streaming de películas o si no corresponde. |
| `Contract` | Tipo de contrato. |
| `PaperlessBilling` | Si usa facturación digital. |
| `PaymentMethod` | Medio de pago. |
| `MonthlyCharges` | Cargo mensual. |
| `TotalCharges` | Cargos acumulados; algunas filas pueden venir vacías. |
| `Churn` | Si dejó el servicio (`Yes`/`No`). Es lo que intenté predecir. |

## Matriz de decisión y cuenta económica

La decisión que probé fue si convenía ofrecer una campaña de retención. La matriz conceptual quedó así:

| Decisión | El cliente se iba (`Churn = Yes`) | El cliente se quedaba (`Churn = No`) |
|---|---|---|
| Contactarlo | Si la campaña funciona, se estima el margen que se conserva y se resta el costo de campaña. | Se paga la campaña aunque no hacía falta evitar una baja. |
| No contactarlo | No se paga la campaña; podría perderse el margen futuro, que esta versión no calcula con datos reales. | No se paga la campaña y no se intenta retenerlo. |

Para cada cliente, el notebook estimó el valor de contactar usando esta fórmula:

`probabilidad de baja × éxito supuesto de la campaña × cargo mensual × meses esperados × margen − costo de campaña`

Si el resultado dio positivo, recomendó contactar al cliente. Usé como ejemplos editables: costo `$20`, seis meses, margen del 40 % y éxito del 30 %. Ninguno de esos cuatro valores viene del CSV ni de resultados observados. Esta versión tampoco buscó distintos umbrales para encontrar un óptimo financiero; eso queda pendiente de revisar y desarrollar.

## Resultados de la ejecución guardada

En la ejecución que quedó guardada dentro del notebook, el conjunto de prueba tuvo 1.409 clientes. XGBoost obtuvo ROC AUC `0.842`, Regresión Logística `0.841` y Random Forest `0.828`; por esa pequeña diferencia, el código eligió XGBoost. La ejecución marcó 445 clientes para contactar.

El código también imprimió `-$8.444,10` como suma económica. Después advertí que esa suma incluye a todos los clientes de prueba, incluso a los que no recomendó contactar, así que no representa el resultado esperado de la campaña dirigida a esos 445. Los valores son una simulación y no un ROI comprobado.

## Límites que dejé visibles

- La selección del modelo se hizo con el ROC AUC del conjunto de prueba; conviene elegirlo con validación dentro de entrenamiento y usar la prueba al final.
- XGBoost recibió dos tratamientos para el desbalance: `RandomOverSampler` y `scale_pos_weight`. Conviene comparar esas opciones por separado.
- La decisión económica usa supuestos; no hay datos de campañas para comprobar su éxito.
- El umbral óptimo que pide el proyecto todavía no está calculado.
