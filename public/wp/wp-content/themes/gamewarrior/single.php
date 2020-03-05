<?php
get_header();
?>

    <body>
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- NAV-->
    <?php
    get_template_part('nav');
    ?>

    <!-- Page info section -->
    <section class="page-info-section set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/page-top-bg/4.jpg">
        <div class="pi-content">
            <div class="container">
                <div class="row">
                    <div class="col-xl-5 col-lg-6 text-white">
                        <h2>Single de Entradas del Blog</h2>
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec malesuada lorem maximus mauris scelerisque, at rutrum nulla dictum.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Page info section -->


    <!-- Page section -->
    <section class="page-section single-blog-page spad">
        <div class="container">
            <div class="row">



            </div>
        </div>
    </section>
    <!-- Page section end -->

<?php
get_footer();
?>