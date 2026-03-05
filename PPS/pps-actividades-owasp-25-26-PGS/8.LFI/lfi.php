<?php

$input_file = $_GET['file'];

// 1. SANEAMIENTO: Eliminamos cualquier ruta maliciosa (../)
// Si el usuario envía "../../../../etc/passwd", esto lo convierte en "passwd"
$safe_file = basename($input_file);

// 2. LISTA BLANCA: Definimos exactamente qué archivos son públicos
$archivos_permitidos = ['hola.txt', 'menu.pdf', 'info.txt'];

// 3. VERIFICACIÓN: Comprobamos si el archivo limpio está en nuestra lista
if (in_array($safe_file, $archivos_permitidos)) {
    // Si está en la lista, lo mostramos
    echo file_get_contents($safe_file);
} else {
    // Si intenta leer /etc/passwd o lfi.php, lo bloqueamos
    echo "<h1>Acceso denegado: Archivo no permitido.</h1>";
}
?>