# Informe: Sanciones por Intrusión en Servidores con Datos Personales

## 1. Uso de NotebookLM para la investigación

Para la realización de este trabajo se utilizó la herramienta **NotebookLM** como apoyo en la búsqueda, consulta y síntesis de información jurídica relacionada con la protección de datos.  
A través de esta herramienta se analizaron documentos oficiales como:

- Reglamento General de Protección de Datos (RGPD).
- Ley Orgánica de Protección de Datos y Garantía de Derechos Digitales (LOPDGDD).
- Ley de Servicios de la Sociedad de la Información (LSSI).
- Código Penal español.
- Esquema Nacional de Seguridad (ENS).

NotebookLM facilitó la identificación de los artículos relevantes, las posibles sanciones económicas y penales, así como la elaboración del caso práctico y el resumen conjunto de consecuencias.

---

---

## 2. Sanciones Administrativas por Intrusión en Servidores

La **intrusión no autorizada en servidores que contienen datos personales** constituye una **violación de seguridad** regulada por el RGPD y la LOPDGDD, afectando especialmente a los principios de:

- Integridad.
- Confidencialidad.
- Seguridad del tratamiento.

### 2.1 Tipos de infracciones

| Tipo de Incumplimiento | Gravedad | Sanción Máxima | Base Legal |
|--------------------------|-----------|-----------------|-------------|
| Violación de principios de tratamiento y confidencialidad (acceso no autorizado a datos) | **Muy grave** | Hasta **20.000.000 €** o el **4% del volumen de negocio anual global** | Art. 5.1.f, 32 y 83.5 RGPD / Art. 72.1.b LOPDGDD |
| Falta de medidas técnicas u organizativas adecuadas | **Grave** | Hasta **10.000.000 €** o el **2% del volumen de negocio** | Art. 32 RGPD / Art. 73.f LOPDGDD |
| Incumplimiento del deber de notificación a la AEPD o a los afectados | **Grave** | Hasta **10.000.000 €** o el **2% del volumen de negocio** | Arts. 33 y 34 RGPD / Arts. 74.r y 74.s LOPDGDD |
| Multas LSSI por infracciones muy graves vinculadas a servicios digitales | **Muy grave** | Entre **150.001 € y 600.000 €** | Art. 39 LSSI |

---

### 2.2 Medidas Correctoras

Además de las multas, la Agencia Española de Protección de Datos (AEPD) puede imponer:

- Bloqueo o limitación del tratamiento de los datos.
- Suspensión de actividades.
- Obligatoriedad de corregir los sistemas de seguridad.

(Art. 67.2 LOPDGDD)

---

### 2.3 Responsabilidad Civil

Los afectados pueden reclamar:

- **Indemnizaciones por daños materiales o inmateriales** derivados de la violación de sus derechos.

(Art. 82 RGPD)

---

---

## 3. Consecuencias Penales (Código Penal)

Además de las sanciones administrativas, la intrusión en sistemas que contienen datos personales puede constituir delito penal.

### 3.1 Tipificación

**Artículo 197 del Código Penal** – Delito de descubrimiento y revelación de secretos:

Se castiga a quien, sin consentimiento:

- Acceda a datos personales de terceros.
- Intercepte comunicaciones privadas.
- Se apodere de datos reservados almacenados en sistemas informáticos.

---

### 3.2 Penas

Las penas pueden incluir:

- **Prisión de 1 a 4 años**.
- **Multa de 12 a 24 meses** para los autores materiales.
- Agravantes si:
  - Los datos son especialmente sensibles (salud, ideología, religión).
  - Hay difusión o venta de la información.
  - Los hechos afectan a gran número de personas.

---

### 3.3 Responsabilidad Penal de la Empresa

Las personas jurídicas también pueden ser responsables conforme al **art. 31 bis del Código Penal**, con posibles sanciones como:

- Multas económicas.
- Suspensión de actividades.
- Prohibición de realizar determinados contratos.
- Clausura de establecimientos.
- Disolución de la empresa en casos extremos.

---

---

## 4. Caso Práctico

### 4.1 El Incidente

**Entidad:** HealthCare Digital S.L.  
**Actividad:** Gestión cloud de historiales médicos.  
**Activos comprometidos:** 500.000 registros de pacientes, incluyendo datos de salud (categorías especiales de datos).  

#### Causa

- Falta de implementación de medidas técnicas y organizativas adecuadas.
- No actualización de servidores frente a una vulnerabilidad conocida.
- Incumplimiento del artículo 32 del RGPD.

#### Resultado

- **Acceso no autorizado** a la base de datos.
- **Exfiltración de la información sensible**.
- Vulneración del principio de confidencialidad.

---

---

## 5. Consecuencias del Caso

### 5.1 Consecuencias Administrativas

| Infracción | Base Legal | Sanción |
|-------------|-------------|-----------|
| Acceso no autorizado a datos | Art. 5.1.f y 83.5 RGPD / Art. 72.1.b LOPDGDD | Hasta **20 M € o 4% del volumen anual** |
| Ausencia de medidas de seguridad adecuadas | Art. 32 RGPD / Art. 73.f LOPDGDD | Hasta **10 M € o 2% del volumen anual** |
| No notificar la brecha a la AEPD o a los usuarios | Art. 33 y 34 RGPD / Art. 74 r y s LOPDGDD | Hasta **10 M € o 2% del volumen anual** |

Además:

- Imposición de medidas correctoras.
- Posible publicación en el **BOE** si la multa supera 1 millón de euros.

---

### 5.2 Consecuencias Civiles

- Reclamaciones colectivas de indemnización por:
  - Daños morales.
  - Pérdida de privacidad.
  - Riesgos de fraude o suplantación.

---

### 5.3 Consecuencias Penales

- Investigación penal por delito del **art. 197 CP**.
- Penas de prisión para los responsables técnicos.
- Multa y sanciones penales para la empresa conforme al art. 31 bis CP.

---

---

## 6. Conclusión

La intrusión en servidores que contienen datos personales tiene **un alto impacto legal**, con consecuencias:

- **Administrativas**: multas millonarias conforme al RGPD y LOPDGDD.
- **Civiles**: indemnizaciones a los afectados por daños.
- **Penales**: penas de prisión y multas personales, además de sanciones a la empresa.

El cumplimiento de las medidas de seguridad del RGPD y del ENS resulta **fundamental para prevenir este tipo de incidentes**, proteger los derechos de los usuarios y evitar graves consecuencias económicas y reputacionales para las organizaciones.

---
