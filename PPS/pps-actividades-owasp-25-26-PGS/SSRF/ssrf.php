<?php
// MITIGACIÓN SSRF

$url = $_GET['url'];

// 1. LISTA BLANCA: Solo estos dominios están permitidos(Por ejemplo).
// Cualquier otra cosa (incluyendo localhost o IPs) será rechazada.
$dominios_permitidos = ['google.com', 'wikipedia.org'];

// Extraemos el 'host' de la URL que nos da el usuario
$host_destino = parse_url($url, PHP_URL_HOST);

// Verificamos si está en la lista
if (!in_array($host_destino, $dominios_permitidos)) {
    die("ACCESO DENEGADO: El dominio '$host_destino' no está autorizado.");
}

// 2. USO DE CURL: Es más seguro que file_get_contents
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

// IMPORTANTE: Forzamos que SOLO use HTTP o HTTPS. 
// Esto bloquea automáticamente el protocolo 'file://' (adiós leer /etc/passwd)
curl_setopt($ch, CURLOPT_PROTOCOLS, CURLPROTO_HTTP | CURLPROTO_HTTPS);
curl_setopt($ch, CURLOPT_REDIR_PROTOCOLS, CURLPROTO_HTTP | CURLPROTO_HTTPS);

$response = curl_exec($ch);

if(curl_errno($ch)){
    echo 'Error en cURL: ' . curl_error($ch);
} else {
    echo $response;
}

curl_close($ch);
?>