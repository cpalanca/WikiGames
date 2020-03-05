<?php
/**
 * Configuración básica de WordPress.
 *
 * Este archivo contiene las siguientes configuraciones: ajustes de MySQL, prefijo de tablas,
 * claves secretas, idioma de WordPress y ABSPATH. Para obtener más información,
 * visita la página del Codex{@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} . Los ajustes de MySQL te los proporcionará tu proveedor de alojamiento web.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** Ajustes de MySQL. Solicita estos datos a tu proveedor de alojamiento web. ** //
/** El nombre de tu base de datos de WordPress */
define( 'DB_NAME', 'wikigames' );

/** Tu nombre de usuario de MySQL */
define( 'DB_USER', 'root' );

/** Tu contraseña de MySQL */
define( 'DB_PASSWORD', 'root' );

/** Host de MySQL (es muy probable que no necesites cambiarlo) */
define( 'DB_HOST', 'localhost' );

/** Codificación de caracteres para la base de datos. */
define( 'DB_CHARSET', 'utf8mb4' );

/** Cotejamiento de la base de datos. No lo modifiques si tienes dudas. */
define('DB_COLLATE', '');

/*ACTUALIZACION DE WORDPRESS PARA SERVER SIN FTP*/
define('FS_METHOD','direct');

/**#@+
 * Claves únicas de autentificación.
 *
 * Define cada clave secreta con una frase aleatoria distinta.
 * Puedes generarlas usando el {@link https://api.wordpress.org/secret-key/1.1/salt/ servicio de claves secretas de WordPress}
 * Puedes cambiar las claves en cualquier momento para invalidar todas las cookies existentes. Esto forzará a todos los usuarios a volver a hacer login.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY', '4fbnQhZ24^(d~{{w>.L=Soe^y-1v*FUw0_tR-njE2Gp|biW& YWwk)r&~`!0xI5a' );
define( 'SECURE_AUTH_KEY', 'HBO904#lTTt!6#HIs7ueM2@ESnlF3%x(k.:q@gMRV.3D.@e$2pRW!T[31vzAP~/U' );
define( 'LOGGED_IN_KEY', 'hzo$u1Ea?3.QclZyMZD6xi.J{$qi9Lg1{c]{J87::uMA~/^fI;ZYBdp|BajK))ns' );
define( 'NONCE_KEY', ' y3Xp{l4e/%:<vgeA4yM4jJnHOx.)k^A]@k5 jhdZ)(o/KP42:a~_T9$yZpbMBn4' );
define( 'AUTH_SALT', 'gW7:_|HWuB,EsNlV;#XUynk1G;q6&H6+X?|#SFIdV?I/]5I)|<X`]N=XbR4?G{nL' );
define( 'SECURE_AUTH_SALT', '}qmmT-,g&1A/il=::67q3o[/B@q<~{IgIK$SBPjXJCm=&ScD:spx~0Ur_CEaMwfe' );
define( 'LOGGED_IN_SALT', ':`u5M6pq nnm_pE)~b{)G*dIpL!-&59) t{>KIjLU`2JVNGSXi:szAIo6F{uhsbR' );
define( 'NONCE_SALT', 'jE}N_F.29@X^AzVf*&O,d@mgAr)<HDhJ{qPH]um1B}|UD(9b8=ER]J/yhdg]I7=!' );

/**#@-*/

/**
 * Prefijo de la base de datos de WordPress.
 *
 * Cambia el prefijo si deseas instalar multiples blogs en una sola base de datos.
 * Emplea solo números, letras y guión bajo.
 */
$table_prefix = 'wg_';


/**
 * Para desarrolladores: modo debug de WordPress.
 *
 * Cambia esto a true para activar la muestra de avisos durante el desarrollo.
 * Se recomienda encarecidamente a los desarrolladores de temas y plugins que usen WP_DEBUG
 * en sus entornos de desarrollo.
 */
define('WP_DEBUG', false);

/* ¡Eso es todo, deja de editar! Feliz blogging */

/** WordPress absolute path to the Wordpress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

