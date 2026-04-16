<?php
// Crear un objeto DOMDocument
$dom = new DOMDocument();
// MITIGACIÓN PRINCIPAL: 
// Eliminamos las flags peligrosas: LIBXML_NOENT y LIBXML_DTDLOAD.
// Al cargar el XML de forma estándar, PHP ignora las entidades externas por defecto.
$dom->loadXML(file_get_contents('php://input'));
// Convertir el XML a SimpleXMLElement (opcional)
$parsed = simplexml_import_dom($dom);
// Mostrar el resultado
echo $parsed;
?>