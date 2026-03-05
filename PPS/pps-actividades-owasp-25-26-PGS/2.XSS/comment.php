<?php
if (isset($_POST['comment'])) {
echo "Comentario publicado: " . htmlspecialchars($_POST['comment'], ENT_QUOTES, 'UTF-8');
}
?>
<form method="post">
<input type="text" name="comment">
<button type="submit">Enviar</button>
</form>
