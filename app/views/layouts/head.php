<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>HRWA</title>
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

  <!-- Mobile viewport optimized: j.mp/bplateviewport -->
  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;">

    <!-- Le styles -->
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/smoothness/jquery-ui.css" rel="stylesheet">
    <link href="js/libs/shadowbox-3.0.3/shadowbox.css" rel="stylesheet">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/ldpd.css?v=2" rel="stylesheet">

    <!-- fav and touch icons -->
    <!--
	<link rel="shortcut icon" href="images/favicon.ico">
	<link rel="apple-touch-icon" href="images/apple-touch-icon.png">
	<link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
    -->

  </head>

  <body>

<!--
<?php
if (!isset($_REQUEST['sdf_preview'])) {
?>
-->
    <div class="topbar">
      <div class="fill">
	<div class="invisible" id="cul_top">
	    <div id="cul_inner"><a href="http://columbia.edu" title="Columbia University - Home">CU</a> &gt; <a href="http://library.columbia.edu" title="Columbia University Libraries - Home">Libraries</a> &gt; <a href="http://library.columbia.edu/indiv/humanrights.html" title="Columbia University Libraries Center for Human Rights Documentation and Research">CHRDR</a><span id="cul_right">HUMAN RIGHTS WEB ARCHIVE at Columbia University</span></div>
	</div>
        <div class="container">
	  <ul id="crowndown" class="nav">
	    <li class="menu">
	    <a href="#" title="External Links @ Columbia" class="menu"><img src="img/crown-bts-24x24.png" /></a>
	    <ul class="menu-dropdown">
		<li><a href="http://columbia.edu">Columbia University - Home</a></li>
		<li><a href="http://library.columbia.edu">Libraries - Home</a></li>
		<li><a title="Columbia University Libraries - CHRDR" href="http://library.columbia.edu/indiv/humanrights.html">CUL Center for Human Rights Documentation and Research</a></li>
	    </ul>
	    </li>
	  </ul>
          <h3 class='topbarlogo'><a href="index.php" title="Human Rights Web Archive at Columbia University - Home">HRWA</a></h3>
	  <form id="topsearchform" action="search.php">
	    <div class="input-append">
		    <input class="span6" type="text" value='<? echo ($q) ? $q : ""; ?>' placeholder="Enter search terms..." size="16" id="q_t" name="q">
		    <label class="add-on"><input type="radio" name="in" id="fsfsearch_t" value="fsf" <?= ($in == 'fsf' || !isset($in)) ? 'checked="checked"' : ''; ?>> FSF</label>
		    <label class="add-on"><input type="radio" name="in" id="asfsearch_t" value="asf" <?= ($in == 'asf') ? 'checked="checked"' : ''; ?>> ASF</label>
		    <label class="add-on hidden"> <a href="#" class="submitss white">Submit</a></label>
	    </div>

	    <!--
	    <?
	    if ($whichpage != 'home') :
		if (isset($_REQUEST['fq']) && !empty($_REQUEST['fq'])) {
		    $hasfq = 1;
		}
		$fqval = '';
		if ($hasfq==1) {
		    echo '<div id="topfqs"><ul class="nav secondary-nav"><li class="menu"><a href="#" class="menu">Active Facets</a><ul class="menu-dropdown">';
		    foreach ($_REQUEST['fq'] as $fq) :
			if (!empty($fq)) { $fqval .= "<li class=\"delfq\">[x] ".htmlspecialchars(urldecode($fq),ENT_QUOTES)."<input type='hidden' name='fq[]' value='".htmlspecialchars(urldecode($fq),ENT_QUOTES)."' /></li>"; }
		    endforeach;
		    echo $fqval.'</ul></li></ul></div>';
		}
	    endif;
	    ?>
	    -->
	  </form>
	  <ul id="dropdown" class="nav secondary-nav">
	    <li class="menu">
	      <a href="#" class="menu">Menu</a>
	      <ul class="menu-dropdown">
	    <li <? if ($whichpage=='home') { ?>class="active"<? } ?>><a href="index.php">HRWA Home</a></li>
	    <li <? if ($whichpage=='about') { ?>class="active"<? } ?>><a href="about.php">About HRWA</a></li>
	    <li><a href="#help" class="donothing">Help &amp; Tips</a></li>
		<li class="divider"></li>
		<li <? if ($whichpage=='browse') { ?>class="active"<? } ?>><a href="browse.php">Browse HRWA</a></li>
	      </ul>
	    </li>
	  </ul>
	</div>
      </div>
    </div> <!-- //.topbar -->
<!--
<?php
}
?>
-->
