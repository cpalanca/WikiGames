<?php
	/*
		Template Name: Contacto
		Theme Name: gamewarrior
		Text Domain: gamewarrior
		Tags: translation-ready
	*/
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
	<section class="page-info-section set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/page-top-bg/5.jpg">
		<div class="pi-content">
			<div class="container">
				<div class="row darken-overlay2">
					<div class="col-xl-5 col-lg-6 text-white pt-3 pb-3">
						<h2><?php _e( 'Contáctanos', 'gamewarrior' ) ?></h2>
						<p><?php _e( 'Cualquier problema que tenga con su aplicación móvil o sobre el sitio no dude en contactar con nosotros.', 'gamewarrior' ) ?></p>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- Page info section -->


	<!-- Page section -->
	<section class="page-section spad contact-page">
		<div class="container">
			<div class="row">
				<div class="col-lg-4 mb-5 mb-lg-0">
					<h4 class="comment-title"><?php _e( 'Datos de contacto', 'gamewarrior' ) ?></h4>
					<p><?php _e( 'Use cualquiera de estos medios para contactar con nosotros.', 'gamewarrior' ) ?></p>
					<div class="row">
						<div class="col-md-9">
							<ul class="contact-info-list">
								<li><div class="cf-left"><?php _e( 'Dirección', 'gamewarrior' ) ?></div><div class="cf-right"><?php _e( 'Calle Sopelana, 11, Oficina 2.11, 28023 Madrid', 'gamewarrior' ) ?></div></li>
								<li><div class="cf-left"><?php _e( 'Teléfono', 'gamewarrior' ) ?></div><div class="cf-right">+34 913 753 366</div></li>
								<li><div class="cf-left">E-mail</div><div class="cf-right">replies@wikigames.com</div></li>
							</ul>
						</div>
					</div>
					<div class="social-links d-flex justify-content-center">
						<a href="#"><i class="fa fa-pinterest"></i></a>
						<a href="#"><i class="fa fa-facebook"></i></a>
						<a href="#"><i class="fa fa-twitter"></i></a>
						<!--a href="#"><i class="fa fa-dribbble"></i></a>
						<a href="#"><i class="fa fa-behance"></i></a>
						<a href="#"><i class="fa fa-linkedin"></i></a-->
					</div>
				</div>
				<div class="col-lg-8">
					<div class="contact-form-warp">
						<h4 class="comment-title"><?php _e( 'Enviar e-mail', 'gamewarrior' ) ?></h4>
						<form class="comment-form">
							<div class="row">
								<div class="col-md-6">
									<input type="text" placeholder="<?php _e( 'Nombre', 'gamewarrior' ) ?>">
								</div>
								<div class="col-md-6">
									<input type="email" placeholder="Email">
								</div>
								<div class="col-lg-12">
									<input type="text" placeholder="<?php _e( 'Asunto', 'gamewarrior' ) ?>">
									<textarea placeholder="<?php _e( 'Mensaje', 'gamewarrior' ) ?>"></textarea>
									<button class="site-btn btn-sm"><?php _e( 'Enviar', 'gamewarrior' ) ?></button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- Page section end -->


<?php
get_footer();
?>