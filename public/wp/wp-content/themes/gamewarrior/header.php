<?php
define( 'WPLANG', 'es_ES' );
if( isset( $_GET[ 'lang' ] ) ) {
    // ... define una variable de sesión llamada WPLANG basada en el parámetro de la URL...
    $locale = $_GET[ 'lang' ];
    // ...y define la constante WPLANG con la variable de sesión WPLANG
    define( 'WPLANG', $locale );
    change_locale($locale);
// si no hay un parámetro "lang" en la URL...
}

?><!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
	<title>WikiGames - Shared Games DataBase</title>
	<meta charset="UTF-8">
    <meta name="description" content="Game Warrior Template">
	<meta name="keywords" content="warrior, game, creative, html">
	<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
	<!-- Favicon -->   
	<link href="<?php echo get_template_directory_uri(); ?>/img/favicon.ico" rel="shortcut icon"/>

	<!-- Google Fonts -->
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,400i,500,500i,700,700i" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="<?php echo get_stylesheet_uri();?>">

	<!--[if lt IE 9]>
	  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
    <?php wp_head(); ?>
</head>