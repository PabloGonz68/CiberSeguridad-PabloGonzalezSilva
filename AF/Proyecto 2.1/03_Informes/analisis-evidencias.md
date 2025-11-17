# **3. Documento de Análisis de Evidencias**

## **3.1 Metodología de análisis aplicada (alta fidelidad)**

1. **Triaging:** identificación de artefactos relevantes.
2. **Volatility Framework:** análisis profundo de memoria.
3. **FTK / análisis de disco:** revisión de persistencias y archivos sospechosos.
4. **Correlación temporal:** relación entre eventos, procesos y artefactos.
5. **Detección de actividad maliciosa:** scripts, malware o activadores ilegales.

---

## **3.2 Análisis de memoria RAM (Volatility)**

### **Perfil:** Win8SP1x64

### **Hallazgos clave:**

* Presencia de múltiples procesos del sistema.
* Servicios sospechosos asociados a herramientas de activación (KMSpico).
* No se detectaron inyecciones activas (`malfind` sin anomalías relevantes).
* `unloadedmodules` muestra drivers de volcado → comportamiento normal del arranque.
* `cmdline`, `dlllist`, `consules` no obtienen PEB por ser crashdump → esperado.

### **Interpretación:**

Volcado funcional pero limitado (WindowsCrashDumpSpace64). Muchos plugins fallan por la estructura de crashdump.

> En un caso real se haría adquisición con LiME o WinPMEM para evitar limitaciones.

---

## **3.3 Análisis de disco (FTK / E01)**

### **Objetivo:** detectar persistencia y archivos alterados.

### **Hallazgos esperados (simulación):**

* Scripts que crean usuarios (`crea_user.py`).
* Registros modificados por KMSpico.
* Posibles tareas programadas.

*(El análisis detallado se agregará cuando completes el procesamiento del E01.)*

---

# **4. Enlace al repositorio de evidencias**

*(Sustituir por enlace final cuando lo subas)*

> [https://github.com/usuario/proyecto-forense-evidencias](https://github.com/usuario/proyecto-forense-evidencias)

---

Si quieres, puedo **rellenar los apartados simulados con contenido más técnico**, añadir tablas, o generar **PDFs listos para entregar**.