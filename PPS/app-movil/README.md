# 🐾 VetClinic - Aplicación Móvil Segura

**Autor:** Pablo González Silva  
**Fecha:** Mayo 2026  
**Módulo/Asignatura:** Puesta en Producción Segura (PPS)  

---

## 📄 Documentación Completa (Memoria y Capturas)

> **⚠️ NOTA IMPORTANTE:** Este archivo es un resumen técnico del proyecto. 
> La documentación completa, que incluye la **metodología de análisis**, las **capturas de pantalla** de la interfaz funcionando y el **informe detallado de mitigación del OWASP Mobile Top 10**, se encuentra en el archivo PDF adjunto en la raíz de este repositorio: 
> 
> 📎 **[`Memoria del Proyecto_ Desarrollo de Aplicación Móvil Segura (VetClinic).pdf`](./Memoria%20del%20Proyecto_%20Desarrollo%20de%20Aplicación%20Móvil%20Segura%20(VetClinic).pdf)**

---

## 🚀 Sobre el Proyecto

**VetClinic** es una aplicación móvil desarrollada como complemento a la plataforma web "Clínica Segura". Está diseñada exclusivamente para el uso de los **clientes** de la clínica, permitiéndoles acceder a la tienda virtual, ver el catálogo de adopciones y gestionar su perfil y mascotas.

Cumpliendo con los requisitos de seguridad, la aplicación **no contiene paneles de administración ni código con privilegios elevados**, delegando toda la lógica de autorización al backend. El ciclo de desarrollo se ha regido por los estándares del **OWASP Mobile Application Security Verification Standard (MASVS)**.

## 🛡️ Enfoque DevSecOps y Seguridad (Resumen)

El desarrollo ha priorizado la seguridad desde el diseño (*Security by Design*), implementando contramedidas específicas contra el **OWASP Mobile Top 10**:

* **Protección de Datos en Reposo:** Uso de `flutter_secure_storage` (Keystore/Keychain) para el cifrado de los tokens JWT de sesión.
* **Protección de Datos en Tránsito:** Implementación de **Certificate Pinning** (Fijación de Certificados) para mitigar ataques *Man-In-The-Middle* (MITM).
* **Protección en Tiempo de Ejecución (RASP):** Integración de **freeRASP** para detectar manipulación del código (Tampering), depuración, e intentos de ingeniería inversa.
* **Gestión de Secretos:** Uso del paquete `envied` para ofuscar credenciales y URLs en el código binario compilado.
* **Autorización Server-Side:** La validación de roles (RBAC) y atributos (ABAC) se realiza íntegramente en el backend alojado en Render.

## 🛠️ Stack Tecnológico

* **Frontend Móvil:** Flutter / Dart (Compilación nativa AOT)
* **Gestión de Estado & Enrutamiento:** BLoC Pattern + GoRouter
* **Backend API:** Node.js, Express (Desplegado en Render)
* **Identity Provider & Base de Datos:** Supabase (PostgreSQL + JWT Auth)
* **Herramientas de Auditoría Recomendadas:** MobSF (SAST) y OWASP ZAP (DAST)

---
*Proyecto desarrollado para la evaluación práctica de arquitecturas seguras y DevSecOps.*