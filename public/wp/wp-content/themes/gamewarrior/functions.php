<?php

function add_scripts_to_my_theme(){
    
        wp_register_script('bootstrap', get_template_directory_uri().'/js/bootstrap.min.js', array('jquery'),null,true);
        wp_enqueue_script('bootstrap');
    
        wp_register_script('jquery', get_template_directory_uri().'/js/jquery-3.2.1.min.js', array('jquery'),null,true);
        wp_enqueue_script('jquery');
    
        wp_register_script('marquee', get_template_directory_uri().'/js/jquery.marquee.min.js', array('jquery'),null,true);
        wp_enqueue_script('marquee');
    
        wp_register_script('main', get_template_directory_uri().'/js/main.js', array('jquery'),null,true);
        wp_enqueue_script('main');
    
        wp_register_script('map', get_template_directory_uri().'/js/map.js', array('jquery'),null,true);
        wp_enqueue_script('map');
        
        wp_register_script('owlcarouseljs', get_template_directory_uri().'/js/owl.carousel.min.js', array('jquery'),null,true);
        wp_enqueue_script('owlcarouseljs');
        
        wp_register_script( 'masonry', 'https://unpkg.com/masonry-layout@4.2.2/dist/masonry.pkgd.min.js', array( 'jquery' ), null, true );
        wp_enqueue_script( 'masonry' );
    }
    add_action('wp_enqueue_scripts', 'add_scripts_to_my_theme');
    
    function add_styles_to_my_theme(){
        
        wp_register_style('animate', get_template_directory_uri() . '/css/animate.css');
        wp_enqueue_style('animate');
    
        wp_register_style('bootstrap', get_template_directory_uri() . '/css/bootstrap.min.css');
        wp_enqueue_style('bootstrap');
    
        wp_register_style('fontawesome', get_template_directory_uri() . '/css/font-awesome.min.css');
        wp_enqueue_style('fontawesome');
    
        wp_register_style('carousel', get_template_directory_uri() . '/css/owl.carousel.css');
        wp_enqueue_style('carousel');
    
        wp_register_style('styles', get_template_directory_uri() . '/css/style.css');
        wp_enqueue_style('styles');
    }
    add_action('wp_enqueue_scripts', 'add_styles_to_my_theme');

    //https://www.joseoliveras.es/archivos-mo-y-po-en-wordpress/
    //https://superadmin.es/blog/wordpress/traducir-plugin-o-tema-wordpress-desarrollo/
    //https://ayudawp.com/cambiar-el-idioma-de-wordpress-automaticamente/

    load_theme_textdomain('gamewarrior', get_template_directory() . '/languages');


    add_filter( 'locale', 'locale_en' );
    function change_locale($locale){
        switch ($locale){
            case "en_GB":
                locale_en();
                load_default_textdomain();
                load_textdomain('gamewarrior', get_template_directory().'/languages/en_GB.mo');
                break;
            case "es_ES":
                locale_es();
                load_default_textdomain();
                load_textdomain('gamewarrior', get_template_directory().'/languages/es_ES.mo');
                break;
        }
    }
    function locale_en(){ return 'en_GB'; }
    function locale_es(){ return 'es_ES'; }

?>