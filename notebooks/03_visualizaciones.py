# Primero cargué el CSV que dejé en el repositorio.
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib.lines import Line2D
from matplotlib.patches import Patch

CARPETA_NOTEBOOK = Path(__file__).resolve().parent
ARCHIVO_CSV = CARPETA_NOTEBOOK.parent / "data_and_sql" / "Telco_Customer_Churn.csv"
URL_DATASET = "https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv"

# Si abrí el script en otra carpeta, lo leí desde el enlace de la cátedra.
if ARCHIVO_CSV.exists():
    datos = pd.read_csv(ARCHIVO_CSV)
else:
    datos = pd.read_csv(URL_DATASET)

# Renombré solo las columnas que necesitaba para que el código se entendiera.
datos = datos.rename(columns={
    "Contract": "tipo_contrato",
    "tenure": "antiguedad_meses",
    "Churn": "churn",
})
datos["churn_si"] = (datos["churn"] == "Yes").astype(int)
sns.set_theme(style="whitegrid")

# Gráfico 1: calculé el porcentaje de bajas en cada tipo de contrato.
tasa_contrato = (
    datos.groupby("tipo_contrato", as_index=False)["churn_si"]
    .mean()
    .sort_values("churn_si", ascending=False)
)
fig, ax = plt.subplots(figsize=(9, 5))
sns.barplot(data=tasa_contrato, x="tipo_contrato", y="churn_si", color="#328c8c", ax=ax)
ax.set_title("Tasa de bajas por tipo de contrato")
ax.set_xlabel("Tipo de contrato")
ax.set_ylabel("Porcentaje de clientes que se fueron")
ax.set_ylim(0, max(tasa_contrato["churn_si"]) * 1.18)
for barra, tasa in zip(ax.patches, tasa_contrato["churn_si"]):
    ax.annotate(
        f"{tasa * 100:.1f}%",
        (barra.get_x() + barra.get_width() / 2, barra.get_height()),
        ha="center", va="bottom", fontsize=11, xytext=(0, 4),
        textcoords="offset points",
    )
fig.tight_layout()
fig.savefig(CARPETA_NOTEBOOK / "churn_por_contrato.png", dpi=300, bbox_inches="tight")
plt.close(fig)

# Gráfico 2: comparé la antigüedad de quienes se fueron y quienes siguieron.
colores = {"No": "#238b57", "Yes": "#d1495b"}
fig, ax = plt.subplots(figsize=(9, 5))
sns.kdeplot(
    data=datos,
    x="antiguedad_meses",
    hue="churn",
    hue_order=["No", "Yes"],
    fill=True,
    common_norm=False,
    palette=colores,
    alpha=0.35,
    ax=ax,
)
ax.axvline(12, color="#263238", linestyle="--", linewidth=1.5, label="12 meses")
ax.set_title("Antigüedad de clientes, según si se fueron")
ax.set_xlabel("Antigüedad en meses")
ax.set_ylabel("Densidad")
ax.legend(handles=[
    Patch(facecolor=colores["No"], edgecolor=colores["No"], alpha=0.35, label="No se fue"),
    Patch(facecolor=colores["Yes"], edgecolor=colores["Yes"], alpha=0.35, label="Se fue"),
    Line2D([0], [0], color="#263238", linestyle="--", label="Primer año"),
], title="Churn")
fig.tight_layout()
fig.savefig(CARPETA_NOTEBOOK / "densidad_antiguedad.png", dpi=300, bbox_inches="tight")
plt.close(fig)

# Gráfico 3: pasé a un mapa los valores de ejemplo de la actividad de clase.
matriz = np.array([
    [280, -50],   # Contacto: intervención exitosa o gasto innecesario.
    [-600, 0],    # Sin contacto: pérdida completa o operación normal.
])
fig, ax = plt.subplots(figsize=(8, 5))
sns.heatmap(
    matriz,
    annot=True,
    fmt="d",
    cmap="RdYlGn",
    center=0,
    xticklabels=["Intervención exitosa", "No hacía falta contactar"],
    yticklabels=["Contactar", "No contactar"],
    linewidths=1,
    cbar_kws={"label": "Dólares"},
    ax=ax,
)
ax.set_title("Matriz de impacto financiero de la actividad")
ax.set_xlabel("Qué pasó con la decisión")
ax.set_ylabel("Decisión")
fig.tight_layout()
fig.savefig(CARPETA_NOTEBOOK / "matriz_decision_financiera.png", dpi=300, bbox_inches="tight")
plt.close(fig)

print("Guardé los tres gráficos en la carpeta notebooks.")
