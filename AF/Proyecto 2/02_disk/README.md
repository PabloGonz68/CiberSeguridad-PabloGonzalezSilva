# Por qué no he subido el volcado del disco duro

El volcado del disco duro generado durante el proceso forense **no se ha subido al repositorio** por varias razones importantes:

##  1. Contiene información altamente sensible

Un volcado de disco incluye absolutamente todo: archivos personales, configuraciones, aplicaciones, historiales, posibles credenciales guardadas, etc. Publicarlo supondría una exposición completa del sistema original y un riesgo evidente de privacidad.

##  2. Tamaño demasiado grande para GitHub

Los volcados de disco duro generados por herramientas forenses suelen ocupar **decenas de GB**. GitHub no permite archivos tan grandes, y además no tiene sentido subirlos al repositorio.

##  3. Implicaciones legales y de privacidad

Dependiendo de lo que contenga el disco, podría incluir datos protegidos por normativas como LOPD o GDPR. Subirlo, incluso a un repo privado, sería una mala práctica.

##  4. Se suben únicamente los hashes

Para garantizar la integridad, se han incluido los hashes generados (MD5, SHA1 y SHA256). Estos permiten verificar el archivo sin exponerlo.

