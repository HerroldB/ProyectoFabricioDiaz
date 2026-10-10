# Sistema Predictivo de Retención de Clientes

Este repositorio corresponde al **Entregable 1: repositorio público en GitHub** de Práctica Profesionalizante II. La idea es construir una primera versión simple que permita cargar el dataset, revisarlo, entrenar algunos modelos y estimar si una campaña de retención podría convenir.

## Qué incluye

- `data_and_sql/01_modelo_relacional.sql`: dos tablas sencillas para PostgreSQL: clientes y suscripciones.
- `notebooks/01_churn_baseline.ipynb`: notebook comentado para ejecutar en Google Colab. Incluye carga, limpieza, exploración, entrenamiento, comparación de modelos y una decisión económica de ejemplo.

Este repositorio cubre solamente este entregable. El informe técnico y la presentación oral se preparan aparte.

## Dataset

Se usa el archivo Telco Customer Churn indicado en el material de clase. Es un dataset de ejemplo público de IBM, con **7.043 registros y 21 columnas**. No contiene datos de campañas reales ni valores observados de cuánto cuesta retener a cada cliente.

- Archivo CSV: [Telco-Customer-Churn.csv](https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv)
- Repositorio original: [IBM/telco-customer-churn-on-icp4d](https://github.com/IBM/telco-customer-churn-on-icp4d)

El CSV se descarga desde el notebook; no se copia dentro de este repositorio.

## Cómo ejecutar el notebook

1. Abrir `notebooks/01_churn_baseline.ipynb` en Google Colab.
2. Ejecutar las celdas en orden. La primera instala las dependencias adicionales.
3. El notebook descarga el dataset, revisa los datos, separa entrenamiento y prueba, y compara Regresión Logística, Random Forest y XGBoost.
4. Al final muestra las métricas y guarda `predicciones_para_powerbi.csv` en el entorno de Colab.

La conexión a PostgreSQL es opcional. Para usarla:

1. Crear una base de prueba y ejecutar `data_and_sql/01_modelo_relacional.sql`.
2. Configurar la variable de entorno `DATABASE_URL` en Colab con el acceso a esa base. No guardar contraseñas en el notebook ni en GitHub.
3. Cambiar `CARGAR_EN_POSTGRES` a `True` en la celda indicada. Al volver a ejecutar, se reemplazan los datos de las dos tablas de este proyecto, por eso conviene usar una base de práctica.

## Modelo de datos

El SQL apunta a PostgreSQL, como indica la consigna de la carpeta “Prof Caceres”. `dim_customer` guarda datos básicos del cliente y `fact_subscription` guarda los servicios, cargos y la variable `churn`. Cada cliente tiene una fila en cada tabla; `customer_id` relaciona ambas.

## Diccionario de datos del CSV

| Campo | Descripción |
|---|---|
| `customerID` | Identificador del cliente. |
| `gender` | Género informado en el dataset. |
| `SeniorCitizen` | Indicador numérico de adulto mayor (0/1). |
| `Partner` | Si el cliente tiene pareja (Yes/No). |
| `Dependents` | Si tiene personas dependientes (Yes/No). |
| `tenure` | Antigüedad, en meses. |
| `PhoneService` | Si tiene servicio telefónico. |
| `MultipleLines` | Si tiene más de una línea o no corresponde. |
| `InternetService` | Tipo de servicio de internet. |
| `OnlineSecurity` | Si tiene seguridad en línea o no corresponde. |
| `OnlineBackup` | Si tiene respaldo en línea o no corresponde. |
| `DeviceProtection` | Si tiene protección de dispositivo o no corresponde. |
| `TechSupport` | Si tiene soporte técnico o no corresponde. |
| `StreamingTV` | Si tiene streaming de TV o no corresponde. |
| `StreamingMovies` | Si tiene streaming de películas o no corresponde. |
| `Contract` | Tipo de contrato. |
| `PaperlessBilling` | Si usa facturación digital. |
| `PaymentMethod` | Medio de pago. |
| `MonthlyCharges` | Cargo mensual. |
| `TotalCharges` | Cargos acumulados; algunas filas pueden venir vacías. |
| `Churn` | Si dejó el servicio (Yes/No). Es la variable a predecir. |

## Matriz de decisión y lectura económica

El notebook usa una matriz simple. “Intervenir” significa ofrecer una campaña de retención; “no intervenir” es no hacer esa oferta.

| Situación | Valor usado en esta primera versión |
|---|---|
| Intervenir y el cliente se iba a ir | Beneficio estimado de retenerlo menos el costo de campaña. |
| Intervenir y el cliente no se iba a ir | Se cuenta el costo de campaña como pérdida. |
| No intervenir | Valor de referencia igual a 0. |

Como el CSV no informa el margen, el costo de campaña ni el éxito real de una intervención, el notebook deja estos supuestos editables: costo `20`, permanencia esperada `6` meses, margen `40%` y éxito de campaña `30%`. El cálculo por cliente es:

`valor esperado neto = probabilidad de churn × éxito de campaña × cargo mensual × meses × margen − costo de campaña`

Se recomienda intervenir cuando ese valor da positivo. Son supuestos para probar el funcionamiento, **no resultados observados ni una recomendación comercial real**. El archivo no permite demostrar que una campaña efectivamente evita una baja; para eso harían falta resultados de campañas o un experimento de retención.

## Hallazgos de esta versión

El dataset permite estimar riesgo de baja a partir de las características disponibles y el notebook muestra qué modelo obtiene mejores métricas en la partición de prueba. La parte económica queda expresada como escenario porque los costos y la efectividad de la campaña no están en los datos. Por eso no se afirma un ROI real: se muestra el valor esperado bajo los supuestos elegidos y se puede volver a calcular cambiándolos.

## Límites conocidos

- Es una primera versión para aprender y probar el flujo; no es un sistema listo para decidir sobre clientes reales.
- El balanceo se realiza sólo sobre el conjunto de entrenamiento para no alterar la prueba.
- La calidad del modelo no demuestra que la campaña funcione. Harían falta datos de intervenciones y validación con negocio.
- Las columnas y nombres del dataset se conservan en la tabla de hechos de forma simple; no se busca un modelo relacional más complejo en esta etapa.

