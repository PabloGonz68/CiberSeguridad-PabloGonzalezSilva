<?php
class User {
public $username;
public $isAdmin = false;
}

$jsonInput = $_GET['data'] ?? '';
$data = json_decode($jsonInput);
if (isset($data->isAdmin) && $data->isAdmin==true) {
echo "<h1>Eres Admin (Pero ahora usas JSON, así que es más seguro) 🔒</h1>";
} else {
    echo "<h1>Acceso denegado / Usuario normal 🚫</h1>";
}
?>
