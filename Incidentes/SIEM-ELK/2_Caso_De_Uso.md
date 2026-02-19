# 2. Documento de Caso de Uso

**Control de Cambios**
| Fecha Actualización | Realizado por | Autorizado por | Naturaleza del Cambio |
| :--- | :--- | :--- | :--- |
| 19/02/2026 | Pablo González Silva | Profesor | Creación del caso de uso para Fuerza Bruta SSH e ICMP |

## 1. OBJETIVO

Detectar escaneos de red activos (Ping) e intentos de acceso no autorizados mediante ataques de fuerza bruta por protocolo SSH hacia los servidores corporativos monitorizados por el SOC.

## 2. ALCANCE

Este caso de uso tiene el siguiente alcance:

- Monitoreo del tráfico de red en la interfaz de loopback (`lo`) y externa (`eth0`) del servidor víctima.
- Detección de reconocimiento de red y escaneos (ICMP).
- Protección ante intrusión, acceso indebido y adivinación de credenciales en el puerto TCP 22.

## 3. FUENTES DE EVENTOS

- **Snort:** Intrusion Detection System (IDS) operando en modo NIDS.
- **Filebeat:** Agente recolector responsable del reenvío de alertas al SIEM.

## 4. TIPO DE DATOS

Para la creación de este caso de uso, se requiere el análisis de los siguientes tipos de información:
| Plataforma | Tipo de Log |
| :--- | :--- |
| Snort IDS | Eventos de alertas de seguridad generados en texto plano (`/var/log/snort/alert`) |
| Linux Auth | Eventos de autenticación del sistema operativo (`/var/log/auth.log`) |

## 5. FLUJO LÓGICO

1. El atacante generará tráfico anómalo contra los puertos monitorizados.
2. Se activará una alerta tipo "Ping Detectado" cuando se intercepte un paquete ICMP dirigido a la máquina.
3. Se activará una alerta tipo "SSH Detectado SIMPLE" cuando se detecte un flujo TCP dirigido al puerto 22.
4. Snort registrará el incidente localmente; Filebeat lo leerá y transmitirá a Logstash para su indexado final en Elasticsearch.

## 6. NOTIFICACIÓN

Las alertas serán visualizadas y notificadas en tiempo real en el cuadro de mandos (Dashboard / Discover) de Kibana, pudiendo generar un reporte analítico de los incidentes bajo el índice `filebeat-*`.

## 7. SEVERIDAD

| Alerta / Reporte              | Severidad    |
| :---------------------------- | :----------- |
| Ping Detectado (ICMP)         | Baja / Media |
| SSH Detectado SIMPLE (TCP 22) | Alta         |

## 8. RECOMENDACIÓN

Se sugiere implementar mecanismos automáticos de respuesta como IPS (Fail2Ban) para bloquear IPs de origen tras reiterados intentos fallidos, así como deshabilitar la autenticación interactiva mediante contraseña en SSH, exigiendo el uso de claves públicas.
