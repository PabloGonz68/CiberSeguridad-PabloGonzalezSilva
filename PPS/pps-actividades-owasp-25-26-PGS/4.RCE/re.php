<?php
$allowedActions = ['listar'];
$action = $_GET['action'] ?? '';

if (!in_array($action, $allowedActions, true)) {
    http_response_code(400);
    echo 'Acción no permitida';
    exit;
}

if ($action === 'listar') {
    $files = scandir(__DIR__);
    echo '<pre>' . htmlspecialchars(print_r($files, true)) . '</pre>';
}
?>