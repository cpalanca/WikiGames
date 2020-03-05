<?php
    /*
        Template Name: Buscador
        Theme Name: gamewarrior
        Text Domain: gamewarrior
        Tags: translation-ready
    */
    get_header();
    ini_set('display_errors',1);
    error_reporting('E_ALL');

	define('DB_HOST','localhost');
	define('DB_PASS','root');
	define('DB_USER','root');
	define('DB_NAME','wikigames');
	define('TPP',3);
	include_once('clases/DBConnection.php');
	include_once('clases/Constantes.php');
	
	/*
        //Info de los juegos y la media de valoraciones
        SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
        CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (4,2)) as 'Valoracion'
        FROM valoracion RIGHT JOIN juego ON juego.id = valoracion.idjuego
        GROUP BY id;
        
        //Obtener los mejores valorados
        SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
        CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (4,2)) as 'Valoracion'
        FROM valoracion RIGHT JOIN juego ON juego.id = valoracion.idjuego
        GROUP BY id
        order by 8 desc;
        
        //Juegos con sus comentarios
        SELECT comentario.idjuego, comentario.comentario, juego.id, titulo, tipo, caratula, flanzamiento, descripcion
        FROM comentario INNER JOIN juego ON juego.id = comentario.idjuego
        
        //Juego con sus comentarios y número de comentarios
        SELECT comentario.idjuego, (SELECT count(id) FROM `comentario` WHERE idjuego = juego.id) as 'Número de comentarios',comentario.comentario, juego.id, titulo, tipo, caratula, flanzamiento, descripcion
        FROM comentario INNER JOIN juego ON juego.id = comentario.idjuego
        
        
	*/
?>
<body class="widthmaximo">
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>
    <!-- NAV-->
    <?php
        get_template_part('nav','buscador');
    ?>
    
    <div class="container mb-5 alturamaxima">
        <div class="row sinpadding sinmargen widthmaximo">
            <div class="col-md-12 widthmaximo">
                <?php
                    $pagina = $_GET['pagina'];
                    $listaPrevia = explode(" ",$_GET['lista']);
                    
                	function listWords($campo){
                		$quitar = array(" ", "&", "-", ".", ",", ":", ";", "|", "@", "'","`","%");
                		$listaResult = str_replace($quitar," ", $campo);
                		//$listaResult = htmlentities($campo);
                		$_GET['lista'] = $listaResult;
                		$result = explode(" ", $listaResult);
                		return array_filter($result);
                	}
                
                	function formarConsulta($lista){;
                		$listado = explode(" ",implode(" ",$lista));
                		$sql = " SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
                                CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (3,1)) as 'Valoracion'
                                FROM valoracion RIGHT JOIN juego ON juego.id = valoracion.idjuego
                                WHERE ";
                        
                        if(sizeof($listado) <= 1){
                			$sql .= 'juego.titulo like "%'.$listado[0].'%"';
                		} else {
                			for($i = 0; $i < sizeof($listado); $i++){
                                $sql .= 'juego.titulo like "%'.$listado[$i].'%"';
                				if($i < sizeof($listado)-1){
                					$sql .= " OR ";
                				}
                			}
                        }
                    
                        $sql .= "GROUP BY juego.id ORDER BY juego.id ";
                        return $sql;
                	}
                ?>
                <div>
                <?php
                
                    /*if(isset($_GET['search']) && $_GET['search'] != ""){
                        echo '<h3 style="text-align:center;padding-top:20px;">Resultados para: '.$_GET['search'].' </h3>';
                    }
            
                    if(isset($_GET['lista']) && $_GET['lista'] != ""){
                        echo '<h3 style="text-align:center;padding-top:20px;">Resultados para: '.$_GET['lista'].' </h3>';
                    }*/
                    
                    if($listaPrevia[0] == "" || !isset($_GET['search'])){
                        $consulta = "SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
                            CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (3,1)) as 'Valoracion'
                            FROM valoracion RIGHT JOIN juego ON juego.id = valoracion.idjuego
                            GROUP BY id ORDER BY juego.id DESC";
                        $db = new DBConnection();
                       
            		}else{
            			$consulta = formarConsulta($listaPrevia);
                        $db = new DBConnection();
                    }
            
                    if(isset($_GET['search'])){
            			$listaBuscar = listWords($_GET['search']);
            			$consulta = formarConsulta($listaBuscar);
                        $db = new DBConnection();
                    }
            
                    if($listaPrevia[0] != ""){
            			$consulta = formarConsulta($listaPrevia);
                        $db = new DBConnection();
                    }
                        
                    $tuplas = TPP;
                    $total = $db->getQuery($consulta)->rowCount();
                    $paginasTotales = $total / $tuplas;
                    $paginasTotales = ceil($paginasTotales);
                    
                    if($_GET['pagina'] <1){
                        $_GET['pagina'] = 1;
                    }
                        
                    if($_GET['pagina']>$paginasTotales){
                        $_GET['pagina'] = $paginasTotales;
                    }
                       
            		if($_GET['lista'] != "" && $_GET['pagina'] != ""){
                        $consulta .= " limit ".($_GET['pagina'] -1) * $tuplas.",".$tuplas;
            		} else {
                        if($_GET['pagina'] == ""){
                            $_GET['pagina'] = 1;
                        }
                        $consulta .= " limit ".($_GET['pagina'] -1) * $tuplas.",".$tuplas;
                        $consulta;
                    }
                    
                    if($db->getQuery($consulta)->rowCount() != 0){
                        if(isset($_GET['lista']) && $_GET['lista'] != ""){
                            echo '<h3 style="text-align:center;padding-top:20px;">';
                            _e( 'Resultados para: ', 'gamewarrior' );
                            echo $_GET['lista'].' </h3>';
                        }
                    }else{
                        echo '<h3 style="text-align:center;padding-top:20px;">';
                        _e( 'Ningún resultado para:', 'gamewarrior' );
                        echo $_GET['lista'].' </h3>';
                        ?>
                        
                        <div class="w-100 d-flex justify-content-center alturamaxima">
                            <img class="gameover mt-5" src="<?php echo get_template_directory_uri();?>/img/gameover.png"/>
                        </div>
                        
                        <?php
                    }
                        
                        
            		echo '<div class="grid col-md-12 mb-3 mt-5 d-flex widthmaximo">';	
                	    foreach($db->getQuery($consulta) as $row){
                	    ?>
                	        <a href="<?php echo get_page_link( get_page_by_title('Single-Juego')->ID ); ?>/?idjuego=<?php echo $row['id']?>">
                	        <div class="grid-item grid-item-busqueda masonrycaratulabuscador mb-3 mt-3 ">
                    	       <div class="review-item">
                                    <div class="review-cover set-bg" data-setbg="<?php echo IMAGES_UPLOADPATH."/".$row['caratula'] ?>">
                                        <div class="score yellow">
                                            <?php
                                                if($row['Valoracion'] == "0.0"){
                                                    echo "N/A";
                                                }else{
                                                    echo $row['Valoracion'];
                                                }
                                            ?>
                                        </div>
                                    </div>
                                    <div class="review-text">
                                        <h4><?php echo utf8_encode($row['titulo']) ?></h4>
                                    </div>
                                </div>
                            </div></a>
                        <?php
                		}
                	echo '</div>';
                	
            		$paginasTotales = ceil($paginasTotales);
            
            		if($paginasTotales > 1){
            		    echo '<div class="row"><div class="col-md-12 d-flex justify-content-center">';
                		    echo '<div class="d-flex flex-row flex-nowrap">';
                    			
                                echo "<div class='paginacion'>";
                    
                                if($_GET['pagina'] >1){
                                    $page = $_GET['pagina']-1;
                                    echo "<a href='?pagina=".$page."&lista=".$_GET['lista']."'><p><img class='cuadrado rotatedhalf' src='";
                                    echo get_template_directory_uri()."/img/arrow.svg'></p></a>";
                                }
                                echo "<div class='paginacion'><p>".$_GET['pagina']."</p></div>";
                                if($_GET['pagina'] <$paginasTotales){
                                    $page = $_GET['pagina']+1;
                                    echo "<a href='?pagina=".$page."&lista=".$_GET['lista']."'><p><img class='cuadrado' src='";
                                    echo get_template_directory_uri()."/img/arrow.svg'></p></a>";
                                }
                    			echo "</div>";
                			echo "</div>";
                		echo "</div>";
                		echo "</div>";
                    }
                ?>
                </div>
            </div>
        </div>
    </div>
<?php
    get_footer();
?>