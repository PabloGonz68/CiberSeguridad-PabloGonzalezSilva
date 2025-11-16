# Por qué no he subido el volcado de la RAM

El volcado de memoria RAM tampoco se ha subido al repositorio por motivos similares, aunque incluso más delicados:

##  1. Contiene datos en tiempo real muy sensibles

La RAM almacena información mientras el sistema está encendido: contraseñas, claves, sesiones, procesos activos, tokens, fragmentos de mensajes y mucho más. Es un tipo de evidencia extremadamente delicada.

##  2. Tamaño elevado

Aunque a veces es más pequeño que un disco, sigue siendo demasiado grande para GitHub y poco práctico para subir.

##  3. Riesgo legal elevado

La información en RAM suele no estar cifrada, lo que aumenta el riesgo de exponer datos protegidos.

##  4. Igualmente, se aportan los hashes

Para mantener trazabilidad e integridad, se incluyen los hashes MD5, SHA1 y SHA256 del volcado, sin necesidad de publicar todo su contenido.
