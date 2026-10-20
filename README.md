# Sistema predictivo de retención de clientes

En este proyecto trabajé con el dataset Telco Customer Churn. Primero cargué y revisé los datos. Después preparé un modelo inicial para estimar qué clientes podrían dejar el servicio y armé las tablas para trabajar con MySQL desde MySQL Workbench.

## Archivos

- data_and_sql/01_modelo_relacional.sql: crea la base y las dos tablas en MySQL.
- notebooks/01_churn_baseline.ipynb: descarga y limpia los datos, compara tres modelos y guarda las predicciones para revisar.
- notebooks/02_decision_financiera.ipynb: calcula la decisión económica y el umbral de contacto. Esta parte se agrega en el siguiente paso del trabajo.

## Cómo lo ejecuté

### 1. Preparé la base en MySQL Workbench

1. Abrí MySQL Workbench y me conecté a mi servidor MySQL.
2. Abrí data_and_sql/01_modelo_relacional.sql.
3. Ejecuté el script completo.
4. Revisé que aparecieran la base churn_pp2 y las tablas dim_customer y fact_subscription.

Workbench es el programa que usé para escribir y ejecutar SQL; el servidor MySQL tiene que estar iniciado para que funcione.

### 2. Preparé y revisé los datos en Google Colab

1. Abrí notebooks/01_churn_baseline.ipynb en Google Colab.
2. Ejecuté las celdas en orden.
3. El notebook descargó el CSV indicado en el material de la profesora, revisó sus filas y columnas, limpió los valores vacíos y comparó los modelos.
4. Al final guardó predicciones_para_revision.csv. Ese archivo incluye las predicciones de validación y de prueba.

Para la comparación elegí Regresión Logística, Random Forest y XGBoost. Los comparé con los mismos datos de entrenamiento y miré el ROC AUC y el recall. El ROC AUC me sirvió para comparar el ordenamiento de las probabilidades; el recall me mostró cuántos clientes que realmente se fueron detectó cada modelo. Elegí el de mayor ROC AUC en validación y revisé sus resultados finales en el conjunto de prueba.

### 3. Carga con SQLAlchemy

El notebook deja la carga a MySQL apagada por defecto. Para usarla, primero ejecuté el SQL en Workbench y después configuré el host, usuario y contraseña del servidor en el entorno de Python. La carga usa SQLAlchemy y PyMySQL.

Google Colab se ejecuta en otro equipo, así que no puede conectarse al localhost de mi computadora. Para cargar desde Colab necesito un servidor MySQL al que Colab pueda llegar. Si solo tengo MySQL instalado en mi computadora, puedo ejecutar esa celda desde Python en la misma computadora.

## Datos que usé

El CSV tiene 7.043 filas y 21 columnas. Lo descargué desde el enlace que usa el script de la profesora:

- CSV de Telco Customer Churn: https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv

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
| Contactarlo | La campaña podría conservar parte del margen, si funciona. | Se paga la campaña aunque el cliente se hubiera quedado. |
| No contactarlo | No se paga la campaña y se puede perder el margen futuro. | No se paga la campaña. |

El dataset no trae información de campañas reales, como costo, tasa de éxito o margen futuro. Por eso no tomé esos valores como resultados observados. En la segunda parte dejé los supuestos separados para poder probar el cálculo económico sin presentarlos como datos reales.
