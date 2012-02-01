<? 
/*
 *******************************************************
 * prototype for HRWA by er2576.
 * foot.php
 *******************************************************
*/
?>
    <div class="container">

      <footer id="site_footer">
		
<?php
  // Get the application root directory.  It will be either 'hr-archive' or 'hr-archive-da217'.
  $pattern   = '/ ( .* ( hr-archive [^\/]* ) ) \/ .* /xms';
  preg_match( $pattern, __FILE__, $matches );
  define( 'APPLICATION_DIR' , $matches[2] );
  
  // Get the link for the internal feedback form
  define( 'INTERNAL_FEEDBACK_LINK', '/' . APPLICATION_DIR
		 . '/internal/feedback/internal_feedback_form-01.php');
  
  $internal_feedback_link = INTERNAL_FEEDBACK_LINK;
  $component_name = component_name();

  if ( $component_name ) {
	$internal_feedback_link = INTERNAL_FEEDBACK_LINK . "?components=$component_name";
  }
  // Attempt to set the component param
  function component_name() {
	  if ( 'fsf' == $_GET[ 'in' ] ) {
		  return '10294';
	  } elseif ( 'asf' == $_GET[ 'in' ]
		&& 1 == preg_match( '/search.php$/', $_SERVER[ 'SCRIPT_NAME' ] ) ) {
		  return '10290';
	  } elseif ( preg_match( '/sdf.php$/', $_SERVER[ 'SCRIPT_NAME' ] ) ) {
		  return '10295';
	  } elseif ( preg_match( '/ccf.php$/', $_SERVER[ 'SCRIPT_NAME' ] ) ) {
		  return '10293';
	  } elseif ( preg_match( '/avf.php$/', $_SERVER[ 'SCRIPT_NAME' ] ) ) {
		  return '10291';
	  } elseif ( preg_match( '/browse.php$/', $_SERVER[ 'SCRIPT_NAME' ] ) ) {
		  return '10292';
	  } else {
		  return '';
	  }
  }
  
?>
		
        <p class="alignright"><?php echo '<a href="' . $internal_feedback_link . '">Submit bug report</a>'; ?></p>
	<p id="culcul"><span class="floatright">&copy; Columbia University Libraries 2011</span><a href="http://columbia.edu">CU Home</a> &gt; <a href="http://library.columbia.edu">Libraries Home</a></p>
      </footer>

    </div> <!-- /container -->

  <!--respnd.min.js - https://github.com/scottjehl/Respond - Enables media queries in some unsupported browsers-->
  <script type="text/javascript" src='js/respond.min.js'></script>

  <!-- Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if offline -->
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
  <script>window.jQuery || document.write('<script src="js/libs/jquery-1.6.2.min.js"><\/script>')</script>

  <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
  <script>window.jQuery || document.write('<script src="js/libs/jquery-ui.min.js"><\/script>')</script>

  <!--script type="text/javascript" src="js/libs/shadowbox-3.0.3/shadowbox.js"></script-->
  <script type="text/javascript" src="js/bootstrap-twipsy.js"></script>
  <script type="text/javascript" src="js/bootstrap-dropdown.js"></script>
  <script type="text/javascript" src="js/jquery.tinysort.min.js"></script>

  <!--script>
  //Shadowbox.init();
  </script-->

  <!-- load our custom script last -->
  <script type="text/javascript" src='js/hrwa.js?v=2'></script>

  </body>
</html>
