<?php
/*
        Theme Name: gamewarrior
        Text Domain: gamewarrior
        Tags: translation-ready

*/

    get_header();
    
    include_once('clases/Constantes.php');
    include_once('clases/DBConnection.php');
    include_once('clases/Utils.php');
    $dbh = new DBConnection();
    $con = $dbh->getDBH();
    define("DB_TABLE", 'juego');
    
    $query = "SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
            CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (3,1)) as 'Valoracion'
            FROM " . DB_TABLE. " LEFT JOIN valoracion ON juego.id = valoracion.idjuego
            GROUP BY juego.id LIMIT 5";
    $resultset = $dbh->getQuery($query);

?>
    <body>
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- NAV-->
    <?php
        get_template_part('nav');
        if ($resultset != null) {
    ?>


    <!-- Hero section -->
    <section class="hero-section">
        <div class="hero-slider owl-carousel">
            <?php foreach ($resultset as $row) { ?>
            <div class="hs-item set-bg" data-setbg="<?php echo IMAGES_UPLOADPATH.$row['caratula']; ?>">
                <div class="hs-text darken-overlay3">
                    <div class="container pt-5 pb-5 d-flex flex-column justify-content-center">
                        <h2 class="text-center"><?php echo $row['titulo'] ?></h2>
                        <a href="<?php echo get_page_link( get_page_by_title('Single-Juego')->ID ); ?>/?idjuego=<?php echo $row['id']?>" class="site-btn botonleer"><?php _e( 'Leer', 'gamewarrior' ) ?></a>
                    </div>
                </div>
            </div>
            <?php } ?>
        </div>
    </section>
    <?php
        }     
    ?>
    <!-- Hero section end -->


    <!-- Latest news section -->
    <?php
        get_template_part('banner-last-comments');
    ?>
    <!-- Latest news section end -->


    <!-- Feature section -->
    <section class="feature-section spad">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-6 p-0">
                    <div class="feature-item set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/features/1.jpg">
                        <span class="cata new"><?php _e( 'acción', 'gamewarrior' ) ?></span>
                        <div class="fi-content text-white">
                            <h5><a href="">Darksiders Genesis</a></h5>
                            <a href="" class="fi-comment"><?php _e( 'MIÉRCOLES, 19 DE FEBRERO', 'gamewarrior' ) ?></a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 p-0">
                    <div class="feature-item set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/features/2.jpg">
                        <span class="cata strategy"><?php _e( 'plataformas', 'gamewarrior' ) ?></span>
                        <div class="fi-content text-white">
                            <h5><a href="">Devil May Cry 3</a></h5>
                            <a href="" class="fi-comment"><?php _e( 'JUEVES, 20 DE FEBRERO', 'gamewarrior' ) ?></a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 p-0">
                    <div class="feature-item set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/features/3.jpg">
                        <span class="cata new"><?php _e( 'rpg', 'gamewarrior' ) ?></span>
                        <div class="fi-content text-white">
                            <h5><a href="">The Division 2: Warlords</a></h5>
                            <a href="" class="fi-comment"><?php _e( 'VIERNES, 21 DE FEBRERO', 'gamewarrior' ) ?></a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 p-0">
                    <div class="feature-item set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/features/4.jpg">
                        <span class="cata racing"><?php _e( 'acción', 'gamewarrior' ) ?></span>
                        <div class="fi-content text-white">
                            <h5><a href="">Cyberpunk</a></h5>
                            <a href="" class="fi-comment"><?php _e( 'MARTES, 25 DE FEBRERO', 'gamewarrior' ) ?></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Feature section end -->


    <!-- Recent game section  -->
    <section class="recent-game-section spad set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game-bg.png">
        <div class="container">
            <div class="section-title">
                <h2><?php _e( 'Mejores juegos del 2019', 'gamewarrior' ) ?></h2>
            </div>
            <div class="row">
                <div class="col-lg-4 col-md-6">
                    <div class="recent-game-item">
                        <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/apex.jpg">
                            <div class="cata new">battle royale</div>
                        </div>
                        <div class="rgi-content">
                            <h5>Apex Legends</h5>
                            <p class="text-justify"><?php _e( 'Apex Legends nos sorprendió a todos cuando tomó el formato Battle Royale y lo mejoró, dejándonos en un tiroteo masivo
                                con la capacidad de hacer ping a los elementos para nuestros compañeros de escuadrón y solicitar elementos según sea
                                necesario sin tener que construir una casa a nuestro alrededor.', 'gamewarrior' ) ?></p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="recent-game-item">
                        <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/resident.jpg">
                            <div class="cata racing">survival horror</div>
                        </div>
                        <div class="rgi-content">
                            <h5>Resident Evil 2: Remake</h5>
                            <p class="text-justify"><?php _e( 'Un gran riesgo y uno en el que Capcom superó todas las expectativas: entregar un juego de terror tan importante e influyente como el original.
                            Atrás quedaron los controles del tanque y en su lugar hay un shooter de supervivencia de terror en tercera 
                            persona contemporáneo de alto presupuesto con un brillo de sangre.', 'gamewarrior' ) ?> </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="recent-game-item">
                        <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/jedi.jpg">
                            <div class="cata adventure"><?php _e( 'Scify', 'gamewarrior' ) ?></div>
                        </div>
                        <div class="rgi-content">
                            <h5>Star Wars Jedi: Fallen Order</h5>
                            <p class="text-justify"><?php _e( 'Star Wars Jedi: Fallen Order es el EA más cercano a la hora de capturar lo que hace que Star Wars sea tan especial. 
                            Al igual que la serie de películas anterior, Jedi: Fallen Order toma influencias de toda la tienda, un poco del combate de From Software,
                            una pizca de las piezas de plataformas de Uncharted, entre otros. ', 'gamewarrior' ) ?></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Recent game section end -->


    <!-- Tournaments section -->
    <section class="tournaments-section spad">
        <div class="container">
            <div class="tournament-title"><?php _e( 'Torneos', 'gamewarrior' ) ?></div>
            <div class="row">
                <div class="col-md-6">
                    <div class="tournament-item mb-4 mb-lg-0">
                        <div class="ti-notic"><?php _e( 'Copa Japonesa', 'gamewarrior' ) ?></div>
                        <div class="ti-content">
                            <div class="ti-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/tournament/1.jpg"></div>
                            <div class="ti-text">
                                <h4><?php _e( 'Fortnite', 'gamewarrior' ) ?></h4>
                                <ul>
                                    <li><span><?php _e( 'Comienza:', 'gamewarrior' ) ?></span> <?php _e( '20 Junio, 2020', 'gamewarrior' ) ?></li>
                                    <li><span><?php _e( 'Finaliza:', 'gamewarrior' ) ?></span> <?php _e( '05 Julio, 2020', 'gamewarrior' ) ?></li>
                                    <li><span><?php _e( 'Participantes:', 'gamewarrior' ) ?></span> <?php _e( '256 personas', 'gamewarrior' ) ?></li>
                                    <li><span><?php _e( 'País:', 'gamewarrior' ) ?></span> <?php _e( 'Japón', 'gamewarrior' ) ?></li>
                                </ul>
                                <p><span><?php _e( 'Precio:', 'gamewarrior' ) ?></span> <?php _e( '1er lugar 150k€, 2º lugar: 75k€, 3er lugar: 25k€', 'gamewarrior' ) ?></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="tournament-item">
                        <div class="ti-notic"><?php _e( 'Copa Americana', 'gamewarrior' ) ?></div>
                        <div class="ti-content">
                            <div class="ti-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/tournament/2.jpg"></div>
                            <div class="ti-text">
                                <h4><?php _e( 'Campeonato Mundial', 'gamewarrior' ) ?></h4>
                                <ul>
                                    <li><span><?php _e( 'Comienza:', 'gamewarrior' ) ?></span> <?php _e( '15 Agosto, 2020', 'gamewarrior' ) ?></li>
                                    <li><span><?php _e( 'Finaliza:', 'gamewarrior' ) ?></span> <?php _e( '27 Julio, 2020', 'gamewarrior' ) ?></li>
                                    <li><span><?php _e( 'Participantes:', 'gamewarrior' ) ?></span> <?php _e( '32 equipos', 'gamewarrior' ) ?></li>
                                    <li><span><?php _e( 'País:', 'gamewarrior' ) ?></span> <?php _e( 'Canadá', 'gamewarrior' ) ?></li>
                                </ul>
                                <p><span><?php _e( 'Precio:', 'gamewarrior' ) ?></span> <?php _e( '1er lugar 75k€, 2º lugar: 50k€, 3er lugar: 25k€', 'gamewarrior' ) ?></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Tournaments section bg -->


    <!-- Review section -->
    <!--section class="review-section spad set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/review-bg.png">
        <div class="container">
            <div class="section-title">
                <div class="cata new">new</div>
                <h2>Top 4 Valoraciones</h2>
            </div>
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="review-item">
                        <div class="review-cover set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/review/1.jpg">
                            <div class="score yellow">9.3</div>
                        </div>
                        <div class="review-text">
                            <h5>Assasin’’s Creed</h5>
                            <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit ame.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="review-item">
                        <div class="review-cover set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/review/2.jpg">
                            <div class="score purple">9.5</div>
                        </div>
                        <div class="review-text">
                            <h5>Doom</h5>
                            <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit ame.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="review-item">
                        <div class="review-cover set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/review/3.jpg">
                            <div class="score green">9.1</div>
                        </div>
                        <div class="review-text">
                            <h5>Overwatch</h5>
                            <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit ame.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="review-item">
                        <div class="review-cover set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/review/4.jpg">
                            <div class="score pink">9.7</div>
                        </div>
                        <div class="review-text">
                            <h5>GTA</h5>
                            <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit ame.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section-->
    <!-- Review section end -->
<?php
    get_footer();
?>