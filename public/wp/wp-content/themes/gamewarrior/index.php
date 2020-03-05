<?php
    header("Location:".get_option('home'));
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


    <!-- Latest news section -->
    <?php
    get_template_part('banner-last-comments');
    ?>
    <!-- Latest news section end -->


    <!-- Page info section -->
    <section class="page-info-section set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/page-top-bg/1.jpg">
        <div class="pi-content">
            <div class="container">
                <div class="row">
                    <div class="col-xl-5 col-lg-6 text-white">
                        <h2>Blog</h2>
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec malesuada lorem maximus mauris scelerisque, at rutrum nulla dictum.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Page info section -->


    <!-- Page section -->
    <section class="page-section recent-game-page spad">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="recent-game-item">
                                <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/1.jpg">
                                    <div class="cata new">racing</div>
                                </div>
                                <div class="rgi-content">
                                    <h5>Suspendisse ut justo tem por, rutrum</h5>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit amet, consectetur elit. </p>
                                    <a href="#" class="comment">3 Comments</a>
                                    <div class="rgi-extra">
                                        <div class="rgi-star"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/star.png" alt=""></div>
                                        <div class="rgi-heart"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/heart.png" alt=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-game-item">
                                <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/2.jpg">
                                    <div class="cata racing">racing</div>
                                </div>
                                <div class="rgi-content">
                                    <h5>Susce pulvinar metus nulla, vel  facilisis sem </h5>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit amet, consectetur elit. </p>
                                    <a href="#" class="comment">3 Comments</a>
                                    <div class="rgi-extra">
                                        <div class="rgi-star"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/star.png" alt=""></div>
                                        <div class="rgi-heart"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/heart.png" alt=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-game-item">
                                <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/3.jpg">
                                    <div class="cata adventure">Adventure</div>
                                </div>
                                <div class="rgi-content">
                                    <h5>Susce pulvinar metus nulla, vel  facilisis sem </h5>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit amet, consectetur elit. </p>
                                    <a href="#" class="comment">3 Comments</a>
                                    <div class="rgi-extra">
                                        <div class="rgi-star"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/star.png" alt=""></div>
                                        <div class="rgi-heart"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/heart.png" alt=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-game-item">
                                <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/4.jpg">
                                    <div class="cata new">racing</div>
                                </div>
                                <div class="rgi-content">
                                    <h5>Suspendisse ut justo tem por, rutrum</h5>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit amet, consectetur elit. </p>
                                    <a href="#" class="comment">3 Comments</a>
                                    <div class="rgi-extra">
                                        <div class="rgi-star"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/star.png" alt=""></div>
                                        <div class="rgi-heart"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/heart.png" alt=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-game-item">
                                <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/5.jpg">
                                    <div class="cata racing">racing</div>
                                </div>
                                <div class="rgi-content">
                                    <h5>Susce pulvinar metus nulla, vel  facilisis sem </h5>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit amet, consectetur elit. </p>
                                    <a href="#" class="comment">3 Comments</a>
                                    <div class="rgi-extra">
                                        <div class="rgi-star"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/star.png" alt=""></div>
                                        <div class="rgi-heart"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/heart.png" alt=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-game-item">
                                <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/6.jpg">
                                    <div class="cata adventure">Adventure</div>
                                </div>
                                <div class="rgi-content">
                                    <h5>Susce pulvinar metus nulla, vel  facilisis sem </h5>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit amet, consectetur elit. </p>
                                    <a href="#" class="comment">3 Comments</a>
                                    <div class="rgi-extra">
                                        <div class="rgi-star"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/star.png" alt=""></div>
                                        <div class="rgi-heart"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/heart.png" alt=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-game-item">
                                <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/7.jpg">
                                    <div class="cata new">racing</div>
                                </div>
                                <div class="rgi-content">
                                    <h5>Suspendisse ut justo tem por, rutrum</h5>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit amet, consectetur elit. </p>
                                    <a href="#" class="comment">3 Comments</a>
                                    <div class="rgi-extra">
                                        <div class="rgi-star"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/star.png" alt=""></div>
                                        <div class="rgi-heart"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/heart.png" alt=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-game-item">
                                <div class="rgi-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/recent-game/8.jpg">
                                    <div class="cata racing">racing</div>
                                </div>
                                <div class="rgi-content">
                                    <h5>Susce pulvinar metus nulla, vel  facilisis sem </h5>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipisc ing ipsum dolor sit amet, consectetur elit. </p>
                                    <a href="#" class="comment">3 Comments</a>
                                    <div class="rgi-extra">
                                        <div class="rgi-star"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/star.png" alt=""></div>
                                        <div class="rgi-heart"><img src="<?php echo get_template_directory_uri(); ?>/img/icons/heart.png" alt=""></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="site-pagination">
                        <span class="active">01.</span>
                        <a href="#">02.</a>
                        <a href="#">03.</a>
                    </div>
                </div>
                <!-- sidebar -->
                <div class="col-lg-4 col-md-7 sidebar pt-5 pt-lg-0">
                    <!-- widget -->
                    <div class="widget-item">
                        <form class="search-widget">
                            <input type="text" placeholder="Search">
                            <button><i class="fa fa-search"></i></button>
                        </form>
                    </div>
                    <!-- widget -->
                    <div class="widget-item">
                        <h4 class="widget-title">Latest Posts</h4>
                        <div class="latest-blog">
                            <div class="lb-item">
                                <div class="lb-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/latest-blog/1.jpg"></div>
                                <div class="lb-content">
                                    <div class="lb-date">June 21, 2018</div>
                                    <p>Ipsum dolor sit amet, consectetur adipisc ing consecips</p>
                                    <a href="#" class="lb-author">By Admin</a>
                                </div>
                            </div>
                            <div class="lb-item">
                                <div class="lb-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/latest-blog/2.jpg"></div>
                                <div class="lb-content">
                                    <div class="lb-date">June 21, 2018</div>
                                    <p>Ipsum dolor sit amet, consectetur adipisc ing consecips</p>
                                    <a href="#" class="lb-author">By Admin</a>
                                </div>
                            </div>
                            <div class="lb-item">
                                <div class="lb-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/latest-blog/3.jpg"></div>
                                <div class="lb-content">
                                    <div class="lb-date">June 21, 2018</div>
                                    <p>Ipsum dolor sit amet, consectetur adipisc ing consecips</p>
                                    <a href="#" class="lb-author">By Admin</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- widget -->
                    <div class="widget-item">
                        <h4 class="widget-title">Top Comments</h4>
                        <div class="top-comment">
                            <div class="tc-item">
                                <div class="tc-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/authors/1.jpg"></div>
                                <div class="tc-content">
                                    <p><a href="#">James Smith</a> <span>on</span> Lorem consec ipsum dolor sit amet, co</p>
                                    <div class="tc-date">June 21, 2018</div>
                                </div>
                            </div>
                            <div class="tc-item">
                                <div class="tc-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/authors/2.jpg"></div>
                                <div class="tc-content">
                                    <p><a href="#">Michael James</a> <span>on</span>Cras sit amet sapien aliquam</p>
                                    <div class="tc-date">June 21, 2018</div>
                                </div>
                            </div>
                            <div class="tc-item">
                                <div class="tc-thumb set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/authors/3.jpg"></div>
                                <div class="tc-content">
                                    <p><a href="#">Justin More</a> <span>on</span> Lorem ipsum dolor consecsit amet, co</p>
                                    <div class="tc-date">June 21, 2018</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- widget -->
                    <div class="widget-item">
                        <div class="feature-item set-bg" data-setbg="<?php echo get_template_directory_uri(); ?>/img/features/1.jpg">
                            <span class="cata new">new</span>
                            <div class="fi-content text-white">
                                <h5><a href="#">Suspendisse ut justo tem por, rutrum</a></h5>
                                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. </p>
                                <a href="#" class="fi-comment">3 Comments</a>
                            </div>
                        </div>
                    </div>
                    <!-- widget -->
                    <div class="widget-item">
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
                </div>
            </div>
        </div>
    </section>
    <!-- Page section end -->
<?php
    get_footer();
?>