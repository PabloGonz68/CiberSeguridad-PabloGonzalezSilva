<?php
$db = new PDO("sqlite:/var/www/html/data.db");
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST["username"];
    $password = $_POST["password"];
    $query = "SELECT * FROM users WHERE name = ? AND passwd = ?";
    echo "Consulta ejecutada: " . $query . "<br>";
    $stmt = $db->prepare($query);
    $stmt->execute([$username, $password]);
    $resultados = $stmt->fetchAll();

    if (count($resultados) > 0) {
        echo "Inicio de sesión exitoso<br>";
        foreach ($resultados as $row) {
            echo "ID: " . $row['id'] . " - Usuario: " . $row['name'] . " - Contraseña: " . $row['passwd'] . "<br>";
        }
    } else {
        echo "Usuario o contraseña incorrectos";
    }
}
?>
<form method="post">
    <input type="text" name="username" placeholder="Usuario">
    <input type="password" name="password" placeholder="Contraseña">
    <button type="submit">Iniciar Sesión</button>
</form>