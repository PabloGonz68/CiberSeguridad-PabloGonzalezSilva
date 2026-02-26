<?php
session_start();

if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if(isset($_POST['csrf_token']) && hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
        $amount = $_POST["amount"];
        echo "Transferidos $$amount";
    } else {
        echo "Error de seguridad: Petición CSRF bloqueada. Token inválido.";
    }

}
?>
<form method="post">
<input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
<input type="number" name="amount">
<button type="submit">Transferir</button>
</form>
