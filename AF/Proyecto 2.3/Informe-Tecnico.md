# Informe Forense — Análisis Técnico y Ejecutivo

## 1. Resumen Ejecutivo

Este informe presenta los resultados del análisis forense realizado sobre el sistema investigado tras la detección de actividad sospechosa. Durante la investigación se identificó la ejecución no autorizada de scripts mediante **wscript.exe**, que derivó en el lanzamiento de dos cargas maliciosas residentes únicamente en memoria. Ambos artefactos intentaron establecer comunicación con un servidor remoto sin éxito.

La evidencia analizada permite concluir que se trató de un intento de intrusión basado en la ejecución de un **VBScript del lado del usuario**, desplegando payloads orientados a establecer un canal C2. No se hallaron mecanismos de persistencia ni exfiltración efectiva de datos. Todas las evidencias relevantes se encuentran documentadas en el anexo del presente informe.

---

## 2. Descripción General del Análisis

El análisis se llevó a cabo utilizando herramientas de adquisición de memoria y utilidades de análisis basadas en Volatility. A partir de la memoria obtenida se identificaron procesos, conexiones activas, artefactos en ejecución y contenido en el escritorio del usuario.

El análisis se divide en:

* Identificación de procesos activos.
* Análisis de conexiones de red.
* Análisis del contenido del escritorio.
* Correlación de eventos con el posible vector de intrusión.
* Documentación de evidencias (MAC times, hashes, rutas, tamaños, contenido y capturas cuando fue posible).

---

## 2.3 Procesos Detectados Durante el Análisis de Memoria

Durante la revisión del volcado de memoria obtenido en la fase de adquisición, se identificaron varios procesos cuya actividad no corresponde al funcionamiento habitual del sistema. La mayor parte de estos procesos fueron generados por **wscript.exe**, ejecutor de scripts VBScript, lo cual indica que el punto de entrada de la actividad maliciosa probablemente fue un archivo .vbs o un mecanismo similar.

### Proceso 1 — Carga principal en memoria

**Nombre:** `QkryuzzwVu.exe`
**PID:** 944
**Padre:** `wscript.exe`
**Persistencia:** No identificada en disco (solo residente en memoria).
**Observaciones:**

* Intentos constantes de conexión hacia **10.28.5.1:8081**.
* Todas las conexiones permanecieron en estado **SYN_SENT**, sin respuesta remota.
* Se comporta como un módulo de carga (loader) encargado de contactar con un servidor externo, posiblemente un C2.

### Proceso 2 — Segundo payload

**Nombre:** `KzcmVNSNkYkueQf.exe`
**PID:** 2960
**Padre:** `wscript.exe`
**Persistencia:** No detectada.
**Observaciones:**

* Intentos de conexión hacia **10.28.5.1**, esta vez sobre el puerto **53**.
* Estado **SYN_SENT**, sin respuesta.
* Comportamiento coherente con un componente que intenta establecer canal de comunicación o exfiltración.

### Proceso detonador — Motor de ejecución del script

**Nombre:** `wscript.exe`
**PIDs implicados:** 2816 y 2824
**Rol:**

* Ejecutó el script responsable de lanzar los procesos maliciosos.
* No se observaron argumentos legítimos que justifiquen su ejecución.
* Constituye el punto inicial de la cadena de actividad maliciosa.

### Resumen de la Cadena de Procesos

1. `wscript.exe` se ejecuta sin justificación aparente.
2. El script dispara dos procesos con nombres aleatorios, ambos cargados directamente en memoria.
3. Cada proceso intenta conectarse a un mismo host remoto, pero en puertos distintos.
4. Ninguno de los payloads logró establecer comunicación efectiva.
5. No se detectaron mecanismos de persistencia en servicios o claves del sistema.

### Tabla Resumen de Actividad

| Proceso             | PID         | Proceso Padre | Conexión Intentada | Estado   | Observaciones             |
| ------------------- | ----------- | ------------- | ------------------ | -------- | ------------------------- |
| QkryuzzwVu.exe      | 944         | wscript.exe   | 10.28.5.1:8081     | SYN_SENT | Residente sólo en memoria |
| KzcmVNSNkYkueQf.exe | 2960        | wscript.exe   | 10.28.5.1:53       | SYN_SENT | Segundo payload           |
| wscript.exe         | 2816 / 2824 | —             | N/A                | N/A      | Ejecuta el script inicial |

### Relación con la Evidencia Obtenida

Los procesos identificados guardan concordancia con la actividad maliciosa detectada durante el análisis posterior (hashes de ejecutables sospechosos, existencia de scripts en el escritorio, y actividades vistas a través de Volatility). La presencia de estos procesos refuerza la hipótesis de ejecución de malware residente en memoria iniciado por un script automatizado.

---

## 5. Conclusiones

* El sistema fue víctima de la ejecución de malware residente en memoria, activado por un script VBScript.
* Ninguno de los payloads logró establecer comunicación efectiva con un servidor C2.
* No se detectaron mecanismos de persistencia ni exfiltración de información.
* Se recomienda la limpieza del sistema, monitorización continua y restricciones sobre la ejecución de scripts mediante `wscript.exe`.

---

# Anexos — Evidencias Técnicas

## A.1 Hashes de Evidencias

### A.1.1 Volcado de Memoria

**Archivo:** FORENSE-06-20251117-194123.dmp

```
SHA‑256: 9de9757c3314596d27c85970d3ad9195a9e1fac91d80a38968eb39f07f590552
```

### A.1.2 Imagen OVA Original

**Archivo:** FORENSIC_10.ova

```
SHA‑256: daf0ef5255d98276a6912a53611db5c0cbf2cccbb49a180dd7fcc0f95e14930c
```

### A.1.3 Ejecutables KMSpico

```
AutoPico.exe      → 4a714d98ce40f5f3577c306a66cb4a6b1ff8f0bcdff5fa
KMSELDI.exe       → 50ebfa1dd5b147e40244607d5d5be25709ec77ac514cc
Service_KMS.exe   → 2b533757086499e224d5717f94a0f4c33e73bc8763378
```

### A.1.4 Script sospechoso

**Archivo:** crea_user.py

```
SHA‑256: 3492eddf0d302e53dc88340c567d696c46462847c55aa91bdb7674cfd39cea2f
```

### A.1.5 Script con hash fallido

**Archivo:** crea_user.txt

> Intentos fallidos de cálculo de hash SHA‑256 debido a error de volumen externo (0x800703ee).

---

## A.2 Capturas y Evidencia de Procesos

* Capturas de Volatility mostrando procesos activos (`pslist.txt`, `psscan.txt`) y conexiones (`netscan.txt`).
* Scripts presentes en el escritorio, vinculados a la ejecución de payloads.
* Archivo de volcado de memoria verificado con hash.

---

## A.3 Conexiones de Red Detectadas

| Proceso             | IP Remota | Puerto | Estado   |
| ------------------- | --------- | ------ | -------- |
| QkryuzzwVu.exe      | 10.28.5.1 | 8081   | SYN_SENT |
| KzcmVNSNkYkueQf.exe | 10.28.5.1 | 53     | SYN_SENT |

