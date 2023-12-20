<?php

define('HOST', 'localhost');
define('USER', 'root');
define('PASS', '');
define('DB', 'uas_pbm');

$con = mysqli_connect(HOST,USER,PASS,DB) or die ('unable to connect');

?>