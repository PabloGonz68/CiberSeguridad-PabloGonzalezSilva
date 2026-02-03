# Informe – Puesta en marcha de OWASP Juice Shop

**Alumno:** [Tu nombre]
**Asignatura:** [Nombre de la asignatura]
**Fecha:** [Fecha de entrega]
**Periodo de actividad:** 16/12/2025 – 02/02/2026

---

## 1. Introducción

El objetivo de esta práctica es:

* Poner en marcha la aplicación vulnerable **OWASP Juice Shop**.
* Comenzar a utilizar la plataforma como entorno de entrenamiento.
* Detectar y catalogar al menos una vulnerabilidad presente en la aplicación.

OWASP Juice Shop es una aplicación web intencionadamente vulnerable diseñada para el aprendizaje de seguridad ofensiva y pruebas de penetración.

---

## 2. Puesta en marcha de OWASP Juice Shop

### 2.1 Instalación mediante Docker

Se ejecutó el siguiente comando:

```bash
docker run -d -p 3000:3000 bkimminich/juice-shop
```

### 2.2 Verificación de ejecución

Se accedió desde el navegador a:

```
http://localhost:3000
```

La aplicación inició correctamente.

---

### Evidencia 1 – Contenedor en ejecución

![Contenedor Docker en ejecución](https://raw.githubusercontent.com/bkimminich/juice-shop/master/screenshots/docker.png)

---

### Evidencia 2 – Página principal de Juice Shop

![Pantalla principal Juice Shop](https://raw.githubusercontent.com/bkimminich/juice-shop/master/screenshots/juice-shop-home.png)

---

## 3. Uso de la plataforma de entrenamiento

Una vez iniciada la aplicación:

* Se accedió al panel de desafíos (Score Board).
* Se exploraron las distintas categorías de vulnerabilidades.
* Se intentó resolver vulnerabilidades relacionadas con autenticación y entrada de datos.

---

### Evidencia 3 – Panel de desafíos (Score Board)

![Score Board](https://raw.githubusercontent.com/bkimminich/juice-shop/master/screenshots/score-board.png)

---

## 4. Vulnerabilidad detectada

### 4.1 Tipo de vulnerabilidad

**SQL Injection**

### 4.2 Descripción

Se identificó una vulnerabilidad de **inyección SQL en el formulario de login**.

La aplicación no valida correctamente la entrada del usuario, permitiendo manipular la consulta SQL enviada al servidor.

### 4.3 Prueba realizada

En el campo email se introdujo:

```
' OR 1=1--
```

Y en el campo contraseña cualquier valor.

Esto permitió iniciar sesión sin credenciales válidas.

---

### Evidencia 4 – Formulario de login

![Login Juice Shop](https://raw.githubusercontent.com/bkimminich/juice-shop/master/screenshots/login.png)

---

### Evidencia 5 – Acceso conseguido tras explotación

![Login exitoso](https://raw.githubusercontent.com/bkimminich/juice-shop/master/screenshots/challenge-solved.png)

---

## 5. Análisis técnico

La vulnerabilidad se produce porque:

* No existe validación adecuada del input del usuario.
* La consulta SQL concatena directamente los valores ingresados.
* No se utilizan consultas preparadas (prepared statements).

### Ejemplo conceptual vulnerable:

```sql
SELECT * FROM users WHERE email = '$email' AND password = '$password';
```

El payload `' OR 1=1--` convierte la consulta en:

```sql
SELECT * FROM users WHERE email = '' OR 1=1--' AND password = '';
```

El `OR 1=1` hace que la condición siempre sea verdadera.

---

## 6. Clasificación de la vulnerabilidad

* **Nombre:** SQL Injection
* **Categoría OWASP Top 10:** A03:2021 – Injection
* **Nivel de riesgo:** Alto
* **Impacto:** Acceso no autorizado, robo de información, manipulación de datos.

---

## 7. Medidas de mitigación

* Uso de consultas preparadas (Prepared Statements).
* Validación y sanitización de entradas.
* Uso de ORM seguro.
* Implementación de WAF.
* Principio de mínimo privilegio en base de datos.

---

## 8. Conclusión

La práctica permitió:

* Poner en funcionamiento un entorno vulnerable real.
* Identificar y explotar una vulnerabilidad de tipo SQL Injection.
* Comprender la importancia de la validación de entradas y el uso de consultas parametrizadas.

OWASP Juice Shop es una herramienta efectiva para el aprendizaje práctico de seguridad en aplicaci
