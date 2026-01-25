# Uso de RAG para consultas sobre normativa

## Informe: Sanciones aplicables a la intrusión en servidores con datos personales

**Asignatura:** Uso de RAG para consultas sobre normativa
**Herramienta utilizada:** NotebookLM
**Fecha:** 25/01/2026
**Autor:** Pablo González Silva

---

## 1. Introducción

La protección de datos personales constituye un derecho fundamental reconocido en el ordenamiento jurídico europeo y español. La creciente digitalización de la información ha incrementado los riesgos asociados al acceso no autorizado a sistemas informáticos que almacenan datos personales. En este contexto, resulta esencial analizar las sanciones aplicables cuando se produce una intrusión en servidores que contienen este tipo de información.

El presente informe tiene como objetivo investigar, mediante el uso de NotebookLM (modelo basado en RAG), las consecuencias penales y administrativas derivadas de este tipo de conductas, tomando como referencia el Código Penal español y el Reglamento General de Protección de Datos (RGPD).

---

## 2. Metodología

Para la elaboración de este trabajo se utilizó NotebookLM como herramienta de consulta jurídica basada en recuperación aumentada de información (RAG). Se cargaron como fuentes los siguientes documentos oficiales:

* Código Penal español.
* Reglamento (UE) 2016/679 (RGPD).
* Ley Orgánica 3/2018 de Protección de Datos y Garantía de Derechos Digitales (LOPDGDD).

A partir de estas fuentes se realizaron consultas dirigidas a identificar:

* Los artículos aplicables al acceso no autorizado a sistemas informáticos.
* Las penas previstas en los artículos 197 y 264 del Código Penal.
* Las sanciones administrativas establecidas en el artículo 83 del RGPD.
* Las obligaciones de seguridad recogidas en el artículo 32 del RGPD.

---

## 3. Sanciones aplicables a la intrusión en servidores con datos personales

### 3.1 Responsabilidad penal

La intrusión en servidores que contienen datos personales puede constituir un delito de descubrimiento y revelación de secretos, regulado en el artículo 197 del Código Penal.

Este precepto sanciona el acceso, apoderamiento, utilización o modificación de datos personales almacenados en soportes informáticos cuando se realiza sin autorización.

* **Tipo básico:** prisión de 1 a 4 años y multa de 12 a 24 meses.
* **Si existe difusión o revelación a terceros:** prisión de 2 a 5 años.
* **Si concurren agravantes (datos sensibles o ánimo de lucro):** prisión de 4 a 7 años.

Cuando además se produce destrucción, alteración o inutilización de datos, puede aplicarse el artículo 264 del Código Penal relativo a los daños informáticos:

* **Tipo básico:** prisión de 6 meses a 3 años.
* **Tipo agravado:** prisión de 2 a 5 años y multa proporcional al perjuicio causado.

Las penas pueden agravarse si los hechos afectan a datos especialmente sensibles, a un elevado número de personas, a infraestructuras críticas o si se cometen en el marco de una organización criminal.

---

### 3.2 Responsabilidad administrativa (RGPD)

Además de la responsabilidad penal del autor material, pueden existir consecuencias administrativas para la empresa responsable del tratamiento de los datos.

El artículo 32 del RGPD establece la obligación de aplicar medidas técnicas y organizativas apropiadas para garantizar un nivel de seguridad adecuado al riesgo, incluyendo:

* Cifrado y seudonimización de datos.
* Garantía de confidencialidad, integridad y disponibilidad.
* Evaluación y verificación periódica de la eficacia de las medidas.

El incumplimiento de estas obligaciones puede ser sancionado conforme al artículo 83 del RGPD:

* **Hasta 10.000.000 € o el 2% del volumen de negocio anual global** (infracciones de obligaciones técnicas y organizativas).
* **Hasta 20.000.000 € o el 4% del volumen de negocio anual global** (infracciones de principios básicos y derechos de los interesados).

En España, la autoridad competente para imponer estas sanciones es la Agencia Española de Protección de Datos (AEPD).

---

## 4. Caso práctico

### 4.1 Supuesto de hecho

Una empresa de comercio electrónico almacena en su servidor interno los datos personales y bancarios de miles de clientes. Un empleado del departamento de informática accede sin autorización al servidor, copia la base de datos y la vende a terceros a través de internet.

Además, la empresa no había implementado medidas de seguridad adecuadas, ya que los datos no estaban cifrados ni existía un sistema de autenticación reforzada.

---

### 4.2 Consecuencias penales

El empleado podría ser acusado de un delito de descubrimiento y revelación de secretos conforme al artículo 197 del Código Penal, al haber accedido y difundido datos personales sin autorización.

Dado que existe difusión a terceros y ánimo de lucro, la pena podría situarse entre 4 y 7 años de prisión, además de la correspondiente multa.

Si durante el acceso se hubieran alterado o dañado los sistemas, también podría aplicarse el artículo 264 relativo a daños informáticos.

---

### 4.3 Consecuencias administrativas

La empresa podría ser sancionada por incumplimiento del artículo 32 del RGPD al no haber aplicado medidas técnicas y organizativas adecuadas.

En función de la gravedad, la multa podría alcanzar hasta 10.000.000 € o el 2% del volumen de negocio anual global. Si se considerara vulneración de principios básicos del tratamiento, la sanción podría ascender hasta 20.000.000 € o el 4% del volumen de negocio.

Además, la empresa estaría obligada a notificar la brecha de seguridad a la autoridad de control y, en su caso, a los afectados.

---

## 5. Conclusión

La intrusión en servidores que contienen datos personales puede generar una doble responsabilidad: penal para el autor del acceso ilícito y administrativa para la empresa responsable del tratamiento si no ha adoptado medidas de seguridad adecuadas.

El marco normativo actual establece sanciones severas con el fin de proteger el derecho fundamental a la protección de datos y reforzar la seguridad en el entorno digital.

---
