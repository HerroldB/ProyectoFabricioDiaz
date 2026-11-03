# Evidencia de MySQL Workbench

Capturas del proyecto Telco Customer Churn en el esquema `churn_pp2`. Se editó la zona del cursor para quitar el halo azul. El puntero se movió a un espacio libre distinto en cada captura.

## Carga y validación

- [00. Carga verificada de la base](Carga%20y%20validaci%C3%B3n/00.%20Carga%20verificada%20de%20la%20base.jpg) · 7.043 clientes, 7.043 suscripciones, 1.869 bajas.
- [01. Estado final después de las transacciones](Carga%20y%20validaci%C3%B3n/01.%20Estado%20final%20despu%C3%A9s%20de%20las%20transacciones.jpg) · 7.043 clientes, 7.043 suscripciones, 1.869 bajas, suma de cargos de 456.116,60 y cero altas de prueba.

## Clase 3

- [1. Selección de columnas](Clase%203/1.%20Selecci%C3%B3n%20de%20columnas.jpg) · 7.043 filas.
- [2. Cargo mensual superior a 70](Clase%203/2.%20Cargo%20mensual%20superior%20a%2070.jpg) · 3.583 filas.
- [3a. Contrato mensual y cargo superior a 50](Clase%203/3a.%20Contrato%20mensual%20y%20cargo%20superior%20a%2050.jpg) · 2.761 filas.
- [3b. Contrato mensual o cheque electrónico](Clase%203/3b.%20Contrato%20mensual%20o%20cheque%20electr%C3%B3nico.jpg) · 3.593 filas.
- [4. Pagos electrónicos ordenados por cargo](Clase%203/4.%20Pagos%20electr%C3%B3nicos%20ordenados%20por%20cargo.jpg) · 2.365 filas.
- [5. Los cinco mayores cargos acumulados](Clase%203/5.%20Los%20cinco%20mayores%20cargos%20acumulados.jpg) · 5 filas, ordenadas de mayor a menor.

## Consultas de control

- [01. Total de clientes](Consultas%20de%20control/01.%20Total%20de%20clientes.jpg) · 7.043.
- [02. Total de suscripciones](Consultas%20de%20control/02.%20Total%20de%20suscripciones.jpg) · 7.043.
- [03. Clientes que se fueron y se quedaron](Consultas%20de%20control/03.%20Clientes%20que%20se%20fueron%20y%20se%20quedaron.jpg) · 1.869 bajas y 5.174 permanencias.
- [04. Bajas por tipo de contrato](Consultas%20de%20control/04.%20Bajas%20por%20tipo%20de%20contrato.jpg) · 6 combinaciones de contrato y estado.
- [05. Cargo mensual promedio](Consultas%20de%20control/05.%20Cargo%20mensual%20promedio.jpg) · 61,27 para permanencias y 74,44 para bajas.
- [06. Bajas por género](Consultas%20de%20control/06.%20Bajas%20por%20g%C3%A9nero.jpg) · 4 combinaciones obtenidas con JOIN.

## Clase 4

- [1a. Alta temporal de una suscripción](Clase%204/1a.%20Alta%20temporal%20de%20una%20suscripci%C3%B3n.jpg) · INSERT del cliente y de su suscripción.
- [1b. Verificación del alta temporal](Clase%204/1b.%20Verificaci%C3%B3n%20del%20alta%20temporal.jpg) · El cliente de prueba tiene un cargo de 85,50.
- [2a. Cargo antes del aumento](Clase%204/2a.%20Cargo%20antes%20del%20aumento.jpg) · 29,85.
- [2b. Reajuste del 10 por ciento](Clase%204/2b.%20Reajuste%20del%2010%20por%20ciento.jpg) · El cargo de la muestra sube a 32,84.
- [2c. Reajuste revertido](Clase%204/2c.%20Reajuste%20revertido.jpg) · El cargo de la muestra vuelve a 29,85.
- [3a. Validación antes del borrado](Clase%204/3a.%20Validaci%C3%B3n%20antes%20del%20borrado.jpg) · Se identifica una suscripción con churn = 1.
- [3b. Borrado dentro de la transacción](Clase%204/3b.%20Borrado%20dentro%20de%20la%20transacci%C3%B3n.jpg) · Quedan cero filas coincidentes.
- [3c. Borrado revertido](Clase%204/3c.%20Borrado%20revertido.jpg) · Vuelve a encontrarse una fila.
