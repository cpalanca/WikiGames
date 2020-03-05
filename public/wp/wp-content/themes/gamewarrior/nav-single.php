<?php

/*
        Theme Name: gamewarrior
        Text Domain: gamewarrior
        Tags: translation-ready

*/
?>
<!-- nav section -->
<header class="header-section">
    <div class="container">
        <!-- logo -->
        <a class="site-logo" href="<?php echo home_url() ?>">
            <img src="<?php echo get_template_directory_uri(); ?>/img/logo.png" alt="">
        </a>
        <!--div class="user-panel">
            <a href="#">Login</a>  /  <a href="#">Registro</a>
        </div-->
        <!-- responsive -->
        <div class="nav-switch">
            <i class="fa fa-bars"></i>
        </div>
        <!-- site menu -->
        <nav class="main-menu">
            <ul>
                <li class="nav-item">
                    <a href="<?php echo get_option('home'); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i><?php _e( 'Inicio', 'gamewarrior' ) ?></a>

                </li>
                <li class="nav-item">
                    <a href="<?php echo get_page_link( get_page_by_title('Buscador')->ID ); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i><?php _e( 'Buscador', 'gamewarrior' ) ?></a>
                </li>
                <!--li class="nav-item">
                    <a href="<?php echo get_page_link( get_page_by_title('Blog')->ID ); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i> <?php _e( 'Blog', 'gamewarrior' ) ?></a>
                </li-->
                <!--li class="nav-item">
                    <a href="<?php echo get_page_link( get_page_by_title('Top 10')->ID ); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i> <?php _e( 'Top 10', 'gamewarrior' ) ?></a>
                </li-->
                <li class="nav-item">
                    <a href="<?php echo get_page_link( get_page_by_title('Contacto')->ID ); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i><?php _e( 'Contacto', 'gamewarrior' ) ?></a>
                </li>
            </ul>
        </nav>
    </div>
</header>
<!-- nav section end -->