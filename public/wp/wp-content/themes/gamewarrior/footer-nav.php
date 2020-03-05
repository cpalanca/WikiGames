<!-- Footer section -->
<footer class="footer-section">
    <div class="container">
        <ul class="footer-menu">
            <li>
                <a href="<?php echo get_option('home'); ?>"><i class="nc-icon nc-book-bookmark"></i> <?php _e( 'Inicio', 'gamewarrior' ) ?></a>
            </li>
            <li>
                <a href="<?php echo get_page_link( get_page_by_title('Buscador')->ID ); ?>"><i class="nc-icon nc-book-bookmark"></i><?php _e( 'Buscador', 'gamewarrior' ) ?></a>
            </li>
            <!--li>
                <a href="<?php echo get_page_link( get_page_by_title('Blog')->ID ); ?>"><i class="nc-icon nc-book-bookmark"></i> <?php _e( 'Blog', 'gamewarrior' ) ?></a>
            </li-->
            <!--li>
                <a href="<?php echo get_page_link( get_page_by_title('Top 10')->ID ); ?>"><i class="nc-icon nc-book-bookmark"></i> <?php _e( 'Top 10', 'gamewarrior' ) ?></a>
            </li-->
            <li>
                <a href="<?php echo get_page_link( get_page_by_title('Contacto')->ID ); ?>"><i class="nc-icon nc-book-bookmark"></i> <?php _e( 'Contacto', 'gamewarrior' ) ?></a>
            </li>
        </ul>
        <p class="copyright">
            Copyright ©<script type="text/javascript">document.write(new Date().getFullYear());</script> <?php _e( 'Todos los derechos reservados a', 'gamewarrior' ) ?> 
            WikiGames
        </p>
    </div>
</footer>
<!-- Footer section end -->