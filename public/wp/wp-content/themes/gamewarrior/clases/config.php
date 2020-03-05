<?php

    ini_set('display_error',1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    require_once('Constantes.php');
    require_once('DBConnection.php');

   $dbh = new DBConnection();
   $con = $dbh->getDBH();
   
?>