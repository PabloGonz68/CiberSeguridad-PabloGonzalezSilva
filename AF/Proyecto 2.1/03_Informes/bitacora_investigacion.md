Fecha: 17/11/2025
Hora de inicio: 19:35 PM
Hora en la máquina: 2:35 PM
Analista: Pablo González Silva

## Estado inicial de análisis (fase 1 — identificación):
- La máquina ha sido arrancada desde snapshot “00 - Estado inicial”.
- Se ha iniciado sesión con las credenciales proporcionadas.
- Escritorio visible sin interacción manual.
- Iconos encontrados:
    * crea_user.txt
    * crea_user.py (archivo Python potencialmente malicioso)
    * Papelera de reciclaje
- No se ha ejecutado ningún archivo.
- No se ha navegado por el sistema.
- Objetivo actual: extracción de memoria en vivo.


Se habilita carpeta compartida SOLO para introducir herramienta forense DumpIt.exe.
Explicación: Uso de herramienta portable certificada para volcado de memoria.

Se accede a "Equipo" para verificar la presencia de la carpeta compartida configurada desde el host. 
No se accede a ninguna carpeta del sistema Windows, únicamente al recurso externo dispuesto para la adquisición de memoria.

Se procede a la adquisición de memoria RAM con la herramienta DumpIt.exe (certificada y portable).
No se accede ni se modifica el contenido del sistema.
Acción: ejecutar DumpIt.exe desde dispositivo externo para generar memoria.raw.

19:52 — Se detecta ausencia de unidad óptica en la VM, necesaria para cargar Guest Additions.
Se apaga la máquina manteniendo la integridad del estado original.
Se añade unidad óptica virtual desde VirtualBox (sin alterar el disco de la evidencia).
Se monta VBoxGuestAdditions.iso para habilitar carpeta compartida de forma forense segura.

19:58 — Reinicio tras instalar Guest Additions.
Objetivo: habilitar carpeta compartida en modo solo lectura para introducir DumpIt.exe sin alterar la evidencia.
Se configura carpeta compartida del host:
    - Nombre: carpeta-compartida
    - Modo: Solo lectura
    - Montaje automático
    - Uso exclusivo para volcado de memoria RAM.


20:00 — Se confirma que la carpeta compartida "carpeta-compartida" está visible desde Windows en modo solo lectura.
Se verifica la presencia de la herramienta forense DumpIt.exe sin necesidad de copiar archivos al sistema analizado.
No se ha accedido a ninguna carpeta interna del equipo, únicamente al recurso externo proporcionado.


20:15 — Se detecta error al ejecutar DumpIt.exe debido a bloqueo de controladores no firmados.
Se reinicia la máquina y se accede al menú de Opciones avanzadas de arranque (F8).
Se selecciona "Deshabilitar aplicación de firma de controladores obligatoria".
Windows arranca permitiendo la ejecución de DumpIt.exe.
Esta acción no altera el disco ni la evidencia, solo modifica temporalmente la política de arranque.

20:20 — Volcado de memoria completado exitosamente.
Archivo generado: FORENSE-06-20251117-194123.dmp (ubicación: Z:\carpeta-compartida)
Tamaño: [1.048.128 KB]
Se verifica visualmente la existencia del archivo.
No se ha modificado ningún archivo dentro de C: ni en el sistema analizado.

20:25 — HASH SHA-256 del volcado de memoria:
Archivo: FORENSE-06-20251117-194123.dmp
Ubicación: Z:\carpeta-compartida
SHA-256: [9d e9 75 7c 33 14 59 6d 27 c8 59 70 d3 ad 91 95 a9 e1 fa c9 1d 80 a3 89 68 eb 39
 f0 7f 59 05 52]
Fecha de adquisición: 17/11/2025
Herramienta: CMD(certutil -hashfile FORENSE-06-20251117-194123.dmp SHA256) 
Resultado: Integridad verificada, evidencia protegida.

20:55 — HASH de la evidencia original (OVA) calculado:
Archivo: FORENSIC_10.ova
SHA-256: daf0ef5255d98276a6912a53611db5c0cbf2cccbb49a180dd7fcc0f95e14930c
Motivo: asegurar la integridad de la máquina original, evidencia nunca modificada.

21:10 - Hashes SHA-256 de ejecutables KMSpico

AutoPico.exe
SHA-256:
4a714d98ce40f5f3577c306a66cb4a6b1ff8f0bcdff5fa

 KMSELDI.exe
SHA-256:
50ebfa1dd5b147e40244607d5d5be25709ec77ac514cc

 Service_KMS.exe
SHA-256:
2b533757086499e224d5717f94a0f4c33e73bc8763378


21:18 — Hash SHA‑256 del archivo Python (crea_user.py)

Se calcula el hash del archivo crea_user.py, ubicado en el escritorio del usuario “Administrador”:

Comando ejecutado:

certutil -hashfile C:\Users\Administrador\Desktop\crea_user.py SHA256


Resultado:
SHA256 hash of file C:\Users\Administrador\Desktop\crea_user.py:
3492eddf0d302e53dc88340c567d696c46462847c55aa91bdb7674cfd39cea2f
CertUtil: -hashfile command completed successfully.


Hash final documentado:
3492eddf0d302e53dc88340c567d696c46462847c55aa91bdb7674cfd39cea2f

21:20 — Intento de cálculo del hash de crea_user.txt

Archivo: crea_user.txt
Ubicación: C:\Users\Administrador\Desktop

Se intenta obtener el hash SHA‑256 con el siguiente comando:

certutil -hashfile C:\Users\Administrador\Desktop\crea_user.txt SHA256


Windows devuelve el error:
CertUtil: -hashfile command FAILED: 0x800703ee (WIN32: 1006)
CertUtil: The volume for a file has been externally altered so that the opened file is no longer valid.


Se repite el intento sin éxito. También se ejecuta el comando sin extensión:
certutil -hashfile C:\Users\Administrador\Desktop\crea_user SHA256


Resultado:
CertUtil: -hashfile command FAILED: 0x80070002 (WIN32: 2)
CertUtil: The system cannot find the file specified.


## Fase 2 — Análisis de memoria RAM con Volatility

Fecha: 17/11/2025
Hora de inicio: 22:18
Analista: Pablo González Silva

22:18 — Preparación del entorno

Se ubicó la memoria volcada (FORENSE-06-20251117-194123.dmp) en:
C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\

Se preparó Volatility 2.6 Standalone en:
C:\Users\Usuario\Desktop\volatility_2.6_win64_standalone\volatility_2.6_win64_standalone\

Se determinó que el perfil adecuado es Win8SP1x64, según la salida del plugin imageinfo.

22:20 — Comando imageinfo
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" imageinfo


Resultado: Volatility identificó múltiples posibles perfiles y confirmó que Win8SP1x64 es adecuado.

Advertencias: Alignment of WindowsCrashDumpSpace64 is too small (los plugins serán lentos).

22:22 — Listado de procesos
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 pslist > pslist.txt


Generado: pslist.txt

Objetivo: Listar todos los procesos activos al momento de la captura de memoria.

22:25 — Escaneo profundo de procesos
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 psscan > psscan.txt


Generado: psscan.txt

Objetivo: Detectar procesos ocultos o finalizados recientemente, incluyendo procesos maliciosos.

22:35 — Servicios cargados
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 svcscan > svcscan.txt


Generado: svcscan.txt

Objetivo: Listar servicios de Windows, posibles persistencias maliciosas (ej. KMS).

22:26 — Conexiones de red
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 netscan > netscan.txt


Generado: netscan.txt

Objetivo: Detectar conexiones TCP/UDP activas y puertos abiertos.

22:28 — Comandos ejecutados en procesos
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 cmdline > cmdline.txt


Generado: cmdline.txt

Objetivo: Ver la línea de comandos utilizada por los procesos activos.

22:50 — Consolas activas
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 consoles > consoles.txt


Generado: consoles.txt

Objetivo: Revisar historial de consolas abiertas para detectar actividad manual sospechosa.

22:29 — DLLs cargadas por procesos
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 dlllist > dlllist.txt


Generado: dlllist.txt

Objetivo: Listar módulos DLL cargados para identificar inyecciones o hooks maliciosos.

22:30 — Detección de inyecciones en memoria
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 malfind > malfind.txt


Generado: malfind.txt

Objetivo: Identificar código inyectado en procesos, técnicas de malware residente en memoria.

22:32 — Handles de sistema
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 handles > handles.txt


Generado: handles.txt

Objetivo: Ver identificadores de archivos, mutex y objetos abiertos por procesos.

22:35 — Actividad de usuario (userassist)
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 userassist > userassist.txt


Generado: userassist.txt

Objetivo: Determinar aplicaciones ejecutadas por el usuario para identificar acciones sospechosas.

22:36 — Detección de módulos descargados o descargados y descargados
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 unloadedmodules > unloadedmodules.txt


Generado: unloadedmodules.txt

Objetivo: Revisar módulos que fueron cargados y descargados, potencial malware residente.

22:38 — Intento de extracción de procesos ejecutables
volatility_2.6_win64_standalone.exe -f "C:\Users\Usuario\Documents\CiberSeguridad-PabloGonzalezSilva\AF\Proyecto 2.1\carpeta-compartida\FORENSE-06-20251117-194123.dmp" --profile=Win8SP1x64 procdump -D dumps


Resultado: Error, el directorio dumps no existía.

Acción: Crear directorio dumps para futuras extracciones si es necesario.

## Fase 3 — Adquisición de imagen forense del disco duro

Fecha: 17/11/2025
Hora de inicio: 23:10
Analista: Pablo González Silva

23:10 — Preparación para adquisición de disco
Se procedió a adquirir una imagen forense del disco duro de la máquina virtual usando FTK Imager, ejecutado dentro de la VM.
Objetivo: crear copia forense completa del disco sin alterar la evidencia original.

23:15 — Selección de disco y tipo de imagen

Disco seleccionado: PhysicalDrive0 (disco principal de la VM)

Tipo de imagen: E01 (Expert Witness Format)

Carpeta destino: Z:\carpeta-compartida\disco.E01 (carpeta compartida de solo lectura, evitando modificar el sistema de la VM)

Opciones marcadas:

Verificar imagen después de creada

Calcular MD5 y SHA1

Compresión activada

23:20 — Ejecución de adquisición
La herramienta comenzó la creación de la imagen forense.
Se mantuvo la VM encendida y sin realizar ninguna otra acción durante el proceso.

23:50 — Finalización de adquisición

Imagen creada: disco.E01

Ubicación: Z:\carpeta-compartida

 MD5 checksum:    6f116a9c09edc82464f0298d9b6d9357 : verified
 SHA1 checksum:   5a5e4217a17c808c1ac4a25601105b4853c8d6d2 : verified
 SHA256: FEA1215493CAB73B0B00CD9B8DE0A8371165DDA87862F22BCCBA225FF4437257

Verificación completada con éxito

Integridad de la evidencia asegurada