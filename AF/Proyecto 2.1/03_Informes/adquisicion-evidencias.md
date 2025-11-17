# **Documentos Forenses — Proyecto 2.1**

Pablo González Silva — 17/11/2025

---

# **1. Documento de Adquisición de Evidencias**

## **1.1 Recolección de evidencias**

### **Metodología aplicada por la empresa**

La adquisición se realizó siguiendo la metodología corporativa estandarizada basada en:

1. **Preservación** (no alteración del entorno).
2. **Adquisición controlada y verificable**.
3. **Documentación estricta de cada acción**.
4. **Cadena de custodia ininterrumpida**.

### **Pasos realizados (simulación realista):**

* Arranque desde snapshot inicial.
* Carga de VBoxGuestAdditions solo para habilitar carpetas compartidas en modo **solo lectura**.
* Introducción de DumpIt.exe mediante carpeta externa sin copiar archivos al sistema investigado.
* Ejecución de volcado de memoria en vivo.
* Reinicio temporal para permitir controladores no firmados sin modificar el sistema.
* Extracción de archivo `.dmp` hacia la carpeta compartida.
* Cálculo de hashes SHA‑256.
* Adquisición posterior de imagen del disco mediante FTK Imager en formato **E01**.

> *Notas simuladas:* En un entorno real se incluirían fotografías, firma del analista, y número de expediente.

---

## **1.2 Descripción de la evidencia**

### **Evidencia 1 — Memoria RAM**

* **Tipo:** Volcado de memoria (RAM).
* **Archivo:** `FORENSE-06-20251117-194123.dmp`
* **Tamaño:** 1.048.128 KB
* **Método de adquisición:** DumpIt.exe
* **Motivo:** Análisis de malware en ejecución, procesos y persistencias.

### **Evidencia 2 — Disco duro de la VM**

* **Tipo:** Imagen del disco.
* **Archivo:** `disco.E01`
* **Formato:** E01 (Expert Witness)
* **Método:** FTK Imager
* **Motivo:** Verificar persistencia, artefactos de malware y cambios en el sistema.

### **Evidencia 3 — Archivos sospechosos**

* `crea_user.py`
* `crea_user.txt`
* Ejecutables KMSpico detectados
* Logs generados durante el análisis

---

## **1.3 Cadena de custodia**

| Evidencia            | Fecha      | Descubridor | Recolector | Custodio actual | Ubicación                       |
| -------------------- | ---------- | ----------- | ---------- | --------------- | ------------------------------- |
| Volcado RAM          | 17/11/2025 | Pablo G.S   | Pablo G.S  | Pablo G.S       | SSD cifrado local + repositorio |
| Disco E01            | 17/11/2025 | Pablo G.S   | Pablo G.S  | Pablo G.S       | Carpeta compartida + backup     |
| Archivos sospechosos | 17/11/2025 | Pablo G.S   | Pablo G.S  | Pablo G.S       | Carpeta de trabajo del proyecto |

> *Nota:* En un caso real habría custodia con firmas, numeración de evidencias, etiquetas adhesivas y almacenamiento en caja sellada.

---

## **1.4 Almacenamiento de la evidencia**

* **Repositorio principal:** carpeta compartida de solo lectura.
* **Backup 1:** SSD cifrado con BitLocker.
* **Backup 2:** Repositorio Git privado.

> En una investigación real, el almacenamiento usaría un servidor seguro WORM (Write Once Read Many) o un NAS Forense.

---

## **1.5 Metodología aplicada**

| Fase           | Descripción                                             |
| -------------- | ------------------------------------------------------- |
| Identificación | Revisión del sistema sin interacción.                   |
| Preservación   | Configuración del entorno para no alterar la evidencia. |
| Adquisición    | Obtención de RAM y disco con herramientas certificadas. |
| Verificación   | Cálculo de hashes.                                      |
| Documentación  | Registro de tiempos, herramientas y acciones.           |

---

