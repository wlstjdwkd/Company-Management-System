<?php

$mysql_host = "127.0.0.1";
$mysql_user = "root";
$mysql_pasw = "1";
$mysql_db   = "dhx4";

$conn = mysql_connect($mysql_host,$mysql_user,$mysql_pasw);
mysql_select_db($mysql_db);

?>