<!-- nav section -->
<header class="header-section">
    <div class="container">
        <!-- logo -->
        <a class="site-logo" href="<?php echo home_url() ?>">
            <img src="<?php echo get_template_directory_uri(); ?>/img/logo.png" alt="">
        </a>
        <!-- responsive -->
        <div class="nav-switch">
            <i class="fa fa-bars"></i>
        </div>
        <!-- site menu -->
        <nav class="main-menu">
            <ul>
                <li class="nav-item">
                    <a href="<?php echo get_option('home'); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i>Inicio</a>

                </li>
                <li class="nav-item">
                    <a href="<?php echo get_page_link( get_page_by_title('Buscador')->ID ); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i>Buscador</a>
                </li>
                <!--li class="nav-item">
                    <a href="<?php echo get_page_link( get_page_by_title('Blog')->ID ); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i> Blog</a>
                </li-->
                <!--li class="nav-item">
                    <a href="<?php echo get_page_link( get_page_by_title('Top 10')->ID ); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i> Top 10</a>
                </li-->
                <li class="nav-item">
                    <a href="<?php echo get_page_link( get_page_by_title('Contacto')->ID ); ?>" class="nav-link"><i class="nc-icon nc-book-bookmark"></i> Contacto</a>
                </li>
            </ul>
        </nav>
    </div>
    <div class="w-100 masmargensuperior mb-5">
        <div class="wrap ">
            <form action="<?php echo get_page_link(get_page_by_title('Buscador')->ID);?>/?lang=en_GB" method="get" class="search">
                <input type="text" name="search" class="searchTerm">
                <button type="submit" name="submit" class="searchButton">
                    <i class="fa fa-search icononaranja"></i>
                </button>
            </form>
        </div>
    </div>
</header>
<!-- nav section end -->