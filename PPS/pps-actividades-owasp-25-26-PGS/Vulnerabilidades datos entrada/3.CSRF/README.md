# Resolución de Actividad OWASP: Explotación y Mitigación de CSRF

## Introducción Teórica

El ataque **Cross-Site Request Forgery (CSRF)**, también conocido como "Session Riding", ocurre cuando un sitio web malicioso, correo electrónico o programa provoca que el navegador web del usuario realice una acción no deseada en un sitio de confianza en el que el usuario está actualmente autenticado.

La vulnerabilidad subyacente surge porque los navegadores web envían automáticamente las credenciales "ambientales" (como las cookies de sesión, credenciales de dominio, etc.) con cada solicitud al dominio correspondiente, independientemente de qué pestaña o página web haya originado dicha solicitud. Si el servidor web no dispone de mecanismos para diferenciar entre una petición legítima (originada en su propio formulario) y una petición forzada (desde otro dominio), el ataque tiene éxito.

---

## Fase 1: Análisis y Explotación de la Vulnerabilidad

### Escenario Base

El código original de la aplicación (`transfer.php`) presenta un fallo crítico de validación de origen. La lógica del servidor se limita a comprobar si el método HTTP recibido es `POST` y si existe el parámetro `amount`.

![Página Base](/PPS/pps-actividades-owasp-25-26-PGS/CSRF/img/1.base-page.png)

Al carecer de un mecanismo de validación de intención (como un token anti-CSRF, comprobación de cabeceras Referer/Origin o confirmación adicional del usuario), el servidor es incapaz de verificar si el usuario interactuó genuinamente con el formulario legítimo.

### Vector de Ataque y Ejecución

Para explotar esta vulnerabilidad, se diseña un archivo HTML malicioso (`csrf_attack.html`). La estrategia consiste en crear un formulario oculto y automatizar su envío hacia el servidor vulnerable.
![Página Base](/PPS/pps-actividades-owasp-25-26-PGS/CSRF/img/2.ataque.png)

```html
<form method="post" action="http://localhost/transfer.php">
    <input hidden type="number" name="amount" value="1000">
</form>
<script>
    document.forms[0].submit();
</script>
```

El script de JavaScript integrado ejecuta el método `submit()` inmediatamente tras la carga de la página. Como el navegador de la víctima confía en el servidor localhost, emite la solicitud POST de forma cruzada (Cross-Site) adjuntando automáticamente cualquier credencial o sesión que el usuario tuviera activa.

### Impacto

El servidor procesa la solicitud asumiendo su absoluta legitimidad. La transferencia de **$1000** se ejecuta en segundo plano de forma invisible, demostrando un compromiso total de la integridad de las acciones de la cuenta del usuario.

![Página Base](/PPS/pps-actividades-owasp-25-26-PGS/CSRF/img/3.transferencia-realizada.png)

---

## Fase 2: Estrategia de Mitigación y Securización

Para neutralizar esta vulnerabilidad, se ha implementado el **Patrón de Token Sincronizador (Synchronizer Token Pattern)**. Este es el método de defensa estándar y más robusto recomendado por OWASP contra los ataques CSRF.

La premisa de seguridad es la siguiente: por cada sesión de usuario, el servidor genera un valor aleatorio, único y secreto (el token). Toda petición que altere el estado de la aplicación (como un POST para transferir fondos) debe incluir obligatoriamente este token. Como la política del mismo origen del navegador (**Same-Origin Policy** o SOP) impide que un atacante lea el contenido del sitio legítimo, el atacante no puede extraer este token para inyectarlo en su formulario malicioso.

---

## Implementación Técnica Paso a Paso

### 1. Gestión de Estado (Sesiones)

Se inicializó el manejo de sesiones en el backend usando la función `session_start()`. Esto es fundamental, ya que el servidor necesita un mecanismo persistente para guardar y asociar el token secreto a la sesión específica de la víctima.

### 2. Generación Criptográfica del Token

Para garantizar la aleatoriedad y evitar que el atacante pueda predecir el token mediante ataques de fuerza bruta, se utilizó un generador de números pseudoaleatorios criptográficamente seguro (CSPRNG).

```php
$_SESSION['csrf_token'] = bin2hex(random_bytes(32));
```

La función `random_bytes(32)` genera **256 bits de entropía**. Posteriormente, `bin2hex()` convierte esos bytes en una cadena hexadecimal legible, facilitando su transporte a través del HTML.

### 3. Inyección del Token en la Capa de Presentación

El token se inyectó en el formulario legítimo de `transfer.php` utilizando un campo de tipo hidden.

```html
<input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
```

De esta manera, el navegador lo empaqueta automáticamente junto con el resto de datos del formulario cuando el usuario realiza la acción legítima.

### 4. Validación Robusta en el Backend

Al recibir la petición POST, el código del servidor ahora ejecuta una validación estricta antes de procesar la transacción económica:

* Verifica la existencia del token en la carga útil de la petición (`isset($_POST['csrf_token'])`).
* Compara el token recibido con el token almacenado en la sesión.
* Para evitar vulnerabilidades de canales laterales como los **Timing Attacks**, se emplea la función `hash_equals()`.

Esta función compara ambas cadenas consumiendo exactamente el mismo tiempo de procesamiento independientemente de si fallan en el primer o en el último carácter.

---

## Comprobación de la Mitigación

Al volver a simular el ataque ejecutando el archivo `csrf_attack.html`, el navegador de la víctima envía el POST, pero la petición llega sin el campo `csrf_token` (ya que el atacante lo desconoce). La validación con `hash_equals()` detecta la inconsistencia de inmediato.

El servidor interrumpe el flujo de ejecución, rechaza la transferencia y devuelve un **error de seguridad controlado**, demostrando que la vulnerabilidad CSRF ha sido mitigada correctamente.

![Página Base](/PPS/pps-actividades-owasp-25-26-PGS/CSRF/img/4.Mitigado.png)
