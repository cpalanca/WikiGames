<?php
    /*
        Template Name: Single Juego
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
    
     if(isset($_GET['idjuego'])){
        $idjuego = $_GET['idjuego'];
        $query = "SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
        CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (3,1)) as 'Valoracion'
        FROM " . DB_TABLE. " LEFT JOIN valoracion ON juego.id = valoracion.idjuego
        WHERE juego.id = ".$idjuego." GROUP BY juego.id";
        $resultset = $dbh->getQuery($query);
    }
?>

<body>
	<!-- Page Preloder -->
	<div id="preloder">
		<div class="loader"></div>
	</div>

    <!-- NAV-->
    <?php
        get_template_part('nav','single');
    
        if ($resultset != null) {
            $contador = 1;
            foreach ($resultset as $row) {
                /*
                echo
                    "<tr>".
                    "<th scope='row'>".$contador++."</th>".
                    "<td>".$row['titulo']."</td>".
                    "<td><img src='".IMAGES_UPLOADPATH.$row['caratula']."'/></td>".
                    "<td>".$row['flanzamiento']."</td>".
                    "<td>".$row['descripcion']."</td>".
                    "</tr>";
                */

    ?>

	<!-- Page info section -->
	<section class="page-info-section darken-overlay set-bg" data-setbg="<?php echo IMAGES_UPLOADPATH.$row['caratula'] ?>">
		<div class="pi-content">
			<div class="container">
				<div class="row d-flex justify-content-center">
					<div class="col-xl-5 col-lg-6 text-white">
						<h2><?php
                            $nombreJuego = $row['titulo'];
                            if ( $nombreJuego != "" )
                                echo utf8_encode($nombreJuego);
                            else
                                echo "Nombre Juego ";
                            ?>
                        </h2>
						<p class="filtroclaridad">
                            <?php
                            $excerptJuego = shorten_text($row['descripcion'], 200, '...', true);
                            if ( $excerptJuego != "" )
                                echo utf8_encode($excerptJuego);
                            else
                                echo "Extracto Juego";
                            ?>
                        </p>
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
				<div class="col-lg-8">
					<div class="blog-thumb set-bg" data-setbg="<?php echo IMAGES_UPLOADPATH.$row['caratula']; ?>">
						<div class="rgi-extra">
							<div class="rgi-star d-flex justify-content-center oculto"></div>
							<div class="rgi-star d-flex justify-content-center align-items-center text-white"><?php echo $row['Valoracion'] ?></div>
						</div>
					</div>
					<div class="blog-content">
						<h3><?php
						$numeroComentarios = 0;
                            if ( $nombreJuego != "" )
                                echo utf8_encode($nombreJuego);
                            ?></h3>
                        <h6 class="text-justify mb-3">
                            <?php echo 'Lanzamiento: '.$row['flanzamiento']; ?>
                        </h6>
						<p class="meta-comment">
                            <?php
                                    $queryComments = "SELECT count(comentario) FROM comentario WHERE idjuego = ".$idjuego;
                                    $resultsetComments = $dbh->getQuery($queryComments);
                                    $nComments = $resultsetComments->fetchColumn();
                                    $numeroComentarios = $nComments;
                                    
                            switch($nComments){
                                case 0:
                                    $nComments = __( 'No hay comentarios', 'gamewarrior' );
                                    break;
                                case 1:
                                    $nComments = __( 'Hay 1 comentario', 'gamewarrior' );
                                    break;
                            }
                            if( $nComments > 1 )
                                $nComments = $nComments . ' '. __( 'comentarios', 'gamewarrior' );

                            echo $nComments;

                            ?>
                        <p class="text-justify">
                        <?php
                        $descripcion= $row['descripcion'];
                        if ( $descripcion != "" )
                            echo utf8_encode($descripcion);
                        ?>
                        </p>
					</div>
					<?php
					    if($numeroComentarios != 0){
					        
					?>
					<div class="comment-warp">
						<h4 class="comment-title"><?php _e( 'Últimos Comentarios', 'gamewarrior' ) ?></h4>
						<ul class="comment-list">
                        <?php
                            $queryComments = "SELECT usuario.alias, comentario.comentario FROM usuario JOIN comentario ON usuario.id = comentario.idusuario WHERE comentario.idjuego =".$idjuego." ORDER BY comentario.id DESC LIMIT 5";
                            $resultsetComments = $dbh->getQuery($queryComments);
                                    if ($resultsetComments != null) {
                                        foreach ($resultsetComments as $Comments) {
                                            ?>


                                            <li>
                                                <div class="comment">
                                                    <div class="comment-avator set-bg"
                                                         data-setbg="<?php echo get_template_directory_uri(); ?>/img/authors/<?php echo rand(1, 8); ?>.jpg"></div>
                                                    <div class="comment-content">
                                                        <h5><?php
                                                            $aliasUser = $Comments['alias'];
                                                            if ($aliasUser != "")
                                                                echo $aliasUser;
                                                            else
                                                                echo "Alias del User";
                                                            ?></h5>
                                                        <p>
                                                            <?php
                                                            $comentarioUser = $Comments['comentario'];
                                                            if ($comentarioUser != "")
                                                                echo utf8_encode($comentarioUser);
                                                            else
                                                                echo "Esto es el comentario del usuario";
                                                            ?>
                                                        </p>
                                                    </div>
                                                </div>
                                            </li>


                                            <?php

                                        }
                                    }
                                            ?>
						</ul>
					</div>
					<?php
					    }
					?>
					<!--div class="comment-form-warp">
						<h4 class="comment-title">Dejanos tu opinión</h4>
						<form class="comment-form">
							<div class="row">
								<div class="col-md-6">
									<input type="text" placeholder="Alias">
								</div>
								<div class="col-md-6">
									<input type="email" placeholder="Email">
								</div>
								<div class="col-lg-12">
									<input type="text" placeholder="Id Juego" hidden>
									<textarea placeholder="Mensaje"></textarea>
									<button class="site-btn btn-sm">Enviar</button>
								</div>
							</div>
						</form>
					</div-->
				</div>
				<!-- sidebar -->
				<div class="col-lg-4 col-md-7 sidebar pt-5 pt-lg-0">
					<!-- widget -->
					<div class="widget-item">
						<form class="search-widget" action="<?php echo get_page_link(get_page_by_title('Buscador')->ID);?>">
							<input type="text" name="search" placeholder="<?php _e( 'Buscar', 'gamewarrior' ) ?>">
							<button><i class="fa fa-search"></i></button>
						</form>
					</div>
					<!-- widget -->
					<div class="widget-item">
						<h4 class="widget-title"><?php _e( 'Útimos Juegos Añadidos', 'gamewarrior' ) ?></h4>
						<div class="latest-blog">

                            <?php

                            $query2 = "SELECT * FROM " . DB_TABLE. " WHERE id != ".$idjuego." ORDER BY id DESC LIMIT 3";
                            $resultset2 = $dbh->getQuery($query2);
                                    if ($resultset2 != null) {
                                        foreach ($resultset2 as $row2) {
                                            ?>
                                            <a href="<?php echo get_page_link( get_page_by_title('Single-Juego')->ID ); ?>/?idjuego=<?php echo $row2['id']?>">
                                            <div class="lb-item">
                                                <div class="lb-thumb set-bg"
                                                     data-setbg="<?php echo IMAGES_UPLOADPATH.$row2['caratula'] ?>"></div>
                                                <div class="lb-content">
                                                    <div class="lb-date"><?php echo $row2['titulo'] ?></div>
                                                    <p class="text-justify"><?php
                                                        $excerptJuegoSidebar = shorten_text($row2['descripcion'], 100, '...', true);
                                                        if ( $excerptJuegoSidebar != "" )
                                                            echo utf8_encode($excerptJuegoSidebar);
                                                        else
                                                            echo "Extracto Juego";
                                                        ?></p>
                                                    <a href="#" class="lb-author"><?php echo utf8_encode($row2['tipo']) ?></a>
                                                </div>
                                            </div>
                                            </a>
                                            <?php
                                        }
                                    }
                                            ?>
						</div>
						<h4 class="widget-title mt-5"><?php _e( 'Mejores valorados', 'gamewarrior' ) ?></h4>
						<div class="latest-blog">

                            <?php

                            $query3 = "SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
                                        CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (3,1)) as 'Valoracion'
                                        FROM valoracion RIGHT JOIN juego ON juego.id = valoracion.idjuego
                                        GROUP BY id
                                        ORDER BY 8 DESC
                                        LIMIT 3;";
                            $resultset3 = $dbh->getQuery($query3);
                                    if ($resultset3 != null) {
                                        foreach ($resultset3 as $row3) {
                                            ?>
                                            <a href="<?php echo get_page_link( get_page_by_title('Single-Juego')->ID ); ?>/?idjuego=<?php echo $row3['id']?>">
                                            <div class="lb-item">
                                                <div class="lb-thumb set-bg"
                                                     data-setbg="<?php echo IMAGES_UPLOADPATH.$row3['caratula'] ?>"></div>
                                                <div class="lb-content">
                                                    <div class="lb-date"><?php echo $row3['titulo'] ?></div>
                                                    <p><?php
                                                        $valoracion = $row3['Valoracion'];
                                                        if ( $valoracion != "0.0" )
                                                            echo "Valoración: ".$valoracion;
                                                        else
                                                            echo "Valoración no disponible";
                                                        ?></p>
                                                    <a href="#" class="lb-author"><?php echo utf8_encode($row3['tipo']) ?></a>
                                                </div>
                                            </div>
                                            </a>
                                            <?php
                                        }
                                    }
                                            ?>
						</div>
                            <?php

                            $query4 = " SELECT comentario.idjuego, (SELECT COUNT(id) FROM `comentario` WHERE idjuego = juego.id) AS 'Comentarios',  titulo, tipo, caratula
                                        FROM comentario INNER JOIN juego ON juego.id = comentario.idjuego
                                        GROUP BY juego.id LIMIT 3";
                            $resultset4 = $dbh->getQuery($query4);
                                    if ($resultset4 != null && $resultset4->rowCount() > 0) {
                                    ?>
                                    <h4 class="widget-title mt-5"><?php _e( 'Más comentados', 'gamewarrior' ) ?></h4>
						                <div class="latest-blog">
                                    <?php
                                        foreach ($resultset4 as $row4) {
                                            ?>
                                            <a href="<?php echo get_page_link( get_page_by_title('Single-Juego')->ID ); ?>/?idjuego=<?php echo $row4['idjuego']?>">
                                            <div class="lb-item">
                                                <div class="lb-thumb set-bg"
                                                     data-setbg="<?php echo IMAGES_UPLOADPATH.$row4['caratula'] ?>"></div>
                                                <div class="lb-content">
                                                    <div class="lb-date"><?php echo $row4['titulo'] ?></div>
                                                    <p><?php
                                                        $comentarios = $row4['Comentarios'];
                                                        if ( $comentarios != "0" )
                                                            if($comentarios == "1"){
                                                                echo $comentarios." comentario";
                                                            }else{
                                                                echo $comentarios." comentarios";
                                                            }
                                                        else
                                                            echo "Ningún comentario";
                                                        ?></p>
                                                    <a href="#" class="lb-author"><?php echo utf8_encode($row4['tipo']) ?></a>
                                                </div>
                                            </div>
                                            </a>
                                            <?php
                                        }
                                        echo '</div>';
					                    echo '</div>';
                                    }
                                            ?>
						

					<!--div class="widget-item">
                        <h4 class="widget-title">Juego Destacado</h4>
						<div class="feature-item set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/features/1.jpg">
							<span class="cata new">new</span>
                            <?php
                            //$bestidgamequery =  "SELECT j.id,COUNT(c.comentario),j.titulo,j.descripcion FROM juego j JOIN valoracion v ON j.id = v.idjuego JOIN comentario c ON c.idjuego = v.idjuego where c.idjuego = 1 GROUP BY j.id";
                            //$resultset2 = $dbh->getQuery($bestidgamequery);
                            //if ($resultset2 != null) {
                              //  foreach ($resultset2 as $row2) {
                                    ?>

                                    <div class="fi-content text-white">
                                        <h5><a href="#">Suspendisse ut justo tem por, rutrum</a></h5>
                                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. </p>
                                        <a href="#" class="fi-comment">3 Comments</a>
                                    </div>
                            <?php
                                //}
                            //}
                            ?>


						</div>
					</div-->
					<!-- widget -->
					<!--div class="widget-item">
                        <h4 class="widget-title">Mejor Valoracion</h4>
						<div class="review-item">
							<div class="review-cover set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/review/1.jpg">
								<div class="score yellow">9.3</div>
							</div>
							<div class="review-text">
								<h5>Assasin’’s Creed</h5>
								<p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit ame.</p>
							</div>
						</div>
					</div-->
				</div>
			</div>
		</div>
	</section>
	<!-- Page section end -->
                                    <?php

                                }
                            }

                            ?>
<?php
get_footer();
?>