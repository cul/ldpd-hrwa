jQuery(function($) {

  /*****************
   * GENERAL UI    *
   *****************/

  $('.tabs').tab()

  $('.donothing').click(function (e) {
		alert('this does nothing... yet.');
		return false;
  });
  $('.nofollow').click(function (e) {
		alert('disallowing external (non-cu) clicks for now while testing.');
		return false;
  });
  $('div.alert-message a.close').live('click', function (e) {
	$(this).parent('.alert-message').hide();
	return false;
  });
  $('.alert-link').click(function (e) {
	window.location = $(this).find('a').attr('href');
	//return false;
  });
  $('.alert-jump').live('click', function(e) {
    scrollToTop();
	$('#q').focus();
	if ($(this).find('a').attr('id') == 'focus_fsf') {
	  $('#fsfsearch').prop('checked', true);
	} else {
	  $('#asfsearch').prop('checked', true);
	}
    $('#q').popover('hide');
	return false;
  }).hover(function() { $('#q').popover('show'); }, function() { $('#q').popover('hide'); } );

  /* #q focus and blur */
  $('#q').bind('focus', function(){
    $('#top_q_wrapper').addClass('focused');
  });
  $('#q').bind('blur', function(){
    $('#top_q_wrapper').removeClass('focused');
  });

  /* scroll to top function */
  function scrollToTop() {
    $('body,html').animate({ scrollTop: 0 }, 800);
  }

  /* Links with class .target-blank should be opened in a new window */
  $('a.target-blank').attr('target','_blank');

  /*****************
   * THUMBNAIL     *
   * FONT/BACK     *
   *****************/

  $('#secondary .thumbnail').click(function() {
    $('#document div.thumbnail').attr('href', $(this).attr('href'));
    $('#document div.thumbnail img').attr('src', $(this).attr('href'));
	$('#secondary .thumbnail').addClass('thumbnail-active').not(this).removeClass('thumbnail-active');
	return false;
  });

  /*****************
   * FORMS         *
   *****************/

  /* submit for anchor tags that are meant to submit forms */
  $('.submitss').bind('click',function(e) {
    $(this).closest('form').submit();
    return false;
  });


  /* #q keydown */
	if ($(window).width() > 767 || $(window).height() > 767) {
	  $('#q').bind('keydown', function(){
	    $('#advo_link').parent().addClass('open');
	  });
	}
  /* keep sources dropdown open even after radio click */
  $('#top_q_wrapper .dropdown-menu input, #top_q_wrapper .dropdown-menu label, #home_q_wrapper .dropdown-menu input, #home_q_wrapper .dropdown-menu label').click(function(e) {
    e.stopPropagation();
  });

  /***** search search_type switcher *****/
  var hcurrentradio= $("#clio_home_search input[name='search_type']:checked")[0];
        $('#advo_link span').text($("#clio_home_search input[name='search_type']:checked").next('span').attr('data-shorttitle')); //for firefox
  $('#clio_home_search input[name=search_type]').change(function() {
    var hnewradio= $("#clio_home_search input[name='search_type']:checked")[0];
    if (hnewradio===hcurrentradio) {
        return;
    } else {
        $('#advo_link span').text($("#clio_home_search input[name='search_type']:checked").next('span').attr('data-shorttitle'));
        hcurrentradio= hnewradio;
        hcurrentradio.checked= true;
    }
  });
  var currentradio= $("input[name='search_type']:checked")[0];
        $('#advo_link span').text($("input[name='search_type']:checked").next('span').attr('data-shorttitle')); //for firefox
  $('input[name=search_type]').change(function() {
    var newradio= $("input[name='search_type']:checked")[0];
    if (newradio===currentradio) {
        return;
    } else {
        $('#advo_link span').text($("input[name='search_type']:checked").next('span').attr('data-shorttitle'));
        currentradio= newradio;
        currentradio.checked= true;
    }
  });


  /*****************
   * SORTING HOME  *
   * PAGE BROWSE   *
   * LISTS         *
   *****************/

  function sortState(foo) {
    $('.results_control').find('a').removeClass('btn-success');
    foo.addClass('btn-success');
  }

  //for smart cbf showings
  function showControls() {
    //$('.tab-content .results_control .sort_a-z.btn').click().removeClass('btn-success');
    if (!$('#home-tab-content div.tab-pane.active').hasClass('no-cntrl')) {
			$('#home-tab-content .results_control').show(0, function() {

        if($('#home-tab-content div.tab-pane.active').length > 0)
        {
          $(this).find('.tab-description').html($('#home-tab-content div.tab-pane.active').attr('data-description'));
        }

        if ( $('#home-tab-content div.tab-pane.active').hasClass('no-count') ) {
            $(this).find('.sort_default').hide();
        } else {
            $(this).find('.sort_default').show();
        }
        if ( $('#home-tab-content div.tab-pane.active').hasClass('no-cols') ) {
            $(this).find('#col_control').hide();
        } else {
            $(this).find('#col_control').show();
        }

        if ( $('#home-tab-content div.tab-pane.active').hasClass('yes-featured_image_control') ) {
          $(this).find('#featured_image_control').show();
        } else {
          $(this).find('#featured_image_control').hide();
        }

        if ( $('#home-tab-content div.tab-pane.active').hasClass('no-sort') ) {
            $(this).find('.sort_a-z, .sort_z-a').hide();
        } else {
            $(this).find('.sort_a-z, .sort_z-a').show();
        }

      }
      );
    } else {
			$('#home-tab-content .results_control').hide(0);
    }
  }

  $('.navbar a[rel=tooltip], .navbar label[rel=tooltip]').tooltip({'placement': 'bottom'});
  $('a[rel=tooltip], .results_control a').tooltip({'placement': 'top'});
  $('article span[rel=tooltip], .hero-unit label[rel=tooltip]').css('cursor','pointer').tooltip({'placement': 'top'});
  $('#q').popover({'placement':'bottom', 'trigger':'manual'});

  // for home browse tabs
  $('#home-tab-content .sort_default').live('click', function() { var c = $('#home-tab-content div.tab-pane ul:not(.no-count)'); $('li',c).tinysort('span', {order:"desc"}); });
  $('#home-tab-content .sort_a-z').live('click', function() { var a = $('#home-tab-content div.tab-pane ul'); $('li',a).tinysort({order:"asc"}); });
  $('#home-tab-content .sort_z-a').live('click', function() { var z = $('#home-tab-content div.tab-pane ul'); $('li',z).tinysort({order:"desc"}); });

  // cbf home onload sorting and showing
  $('.tab-content .results_control').not('#home-tab-content .results_control').show();
  showControls();
  if ($.browser.msie) {
    $('#col_control').css('display','none');
  }
  $('ul.tabs li a').live('click', function() { showControls(); $(this).blur(); });

  // cbf home column controls
  // will want to clean up.
  $('.tab-content .results_control .sort_col-1').live('click', function() {
		$('#home-tab-content div.tab-pane > ul:not(.no-cols)')
			.removeClass('cols-two cols-three').addClass('cols-one');
		$(this).parent().parent().find('li.active').removeClass('active');
		$(this).parent().addClass('active');
  });
  $('.tab-content .results_control .sort_col-2').live('click', function() {
		$('#home-tab-content div.tab-pane > ul:not(.no-cols)')
			.removeClass('cols-one cols-three').addClass('cols-two');
		$(this).parent().parent().find('li.active').removeClass('active');
		$(this).parent().addClass('active');
  });
  $('.tab-content .results_control .sort_col-3').live('click', function() {
		$('#home-tab-content div.tab-pane > ul:not(.no-cols)')
			.removeClass('cols-two cols-one').addClass('cols-three');
		$(this).parent().parent().find('li.active').removeClass('active');
		$(this).parent().addClass('active');
  });

  //See Back Of Image Button
  $('.see_back_of_img_btn').each(function(){
    $(this).bind('click', function(){

      var img_jQueryElement = $(this).closest('li').find('img');
      var current_img_src = img_jQueryElement.attr('src');

      var flipside = $(this).attr('data-flipside');
      $(this).attr('data-flipside', img_jQueryElement.attr('src'));
      img_jQueryElement.attr('src', flipside);

      return false;
    });
  });


    //Home page cycling image
      var images = ['0001.jpg', '0002.jpg', '0003.jpg', '0004.jpg', '0005.jpg', '0006.jpg', '0007.jpg', '0010.jpg', '0011.jpg'];
      //$('#inner-headline-outer').css({'background-image': 'url(/assets/slides/' + images[Math.floor(Math.random() * images.length)] + ')'});

    //Site-wide Modals
    $('#modal-gallery').on('load', function () {
        var modalData = $(this).data('modal'),
        // The current, associated link element:
        linkElement = modalData.$links[modalData.options.index];
        // Update the modal, e.g. an element inside the modal with class "info":

        //Parse image url to obtain the root image url so that we can generate image derivitive urls
        var thumb_src = $(linkElement).closest('article').find('a.thumb_link img').attr('src');
        var show_link_to_item = true;
        if(thumb_src == undefined)
        {
          //Then we are on an item level view page instead of a result page
          //So we need to look for the closest #document instead of the closest article
          thumb_src = $(linkElement).closest('#document').find('a.current_image_link').attr('href');
          show_link_to_item = false;
        }
        var img_url_root = thumb_src.substring(0, thumb_src.lastIndexOf('/')) //chop off '/view.png'
        img_url_root = img_url_root.substring(0, img_url_root.lastIndexOf('/')); //chopping off ('/thumb', '/medium', '/large', etc.)
        var img_url_small = img_url_root + '/thumb/download.png';
        var img_url_medium = img_url_root + '/medium/download.png';
        var img_url_large = img_url_root + '/large/download.png';

        $(this).find('.modal-title').text($('img', linkElement).data('info'));
        $(this).find('.modal-view-item').attr('href', $('img', linkElement).closest('article').find('.item-link').attr('href'));
        $(this).find('a.thumb_download').attr('href', img_url_small);
        $(this).find('a.medium_download').attr('href', img_url_medium);
        $(this).find('a.large_download').attr('href', img_url_large);

        if(show_link_to_item)
        {
          $(this).find('#view_item_btn').remove();
          //Copy the View Item button anchor from the item results view, including its onclick event for posting blacklight data to the item-level view page
          ($(linkElement).closest('article').find('a.item-link')).clone(true).attr('id', 'view_item_btn').removeClass('btn-mini').addClass('pull-left').unbind('hover').prependTo($(this).find('.modal-footer'));
        }
        else
        {
          $(this).find('#view_item_btn').hide();
        }

        var possible_flip_side_value = $(linkElement).attr('data-flipside');

        if(possible_flip_side_value !== undefined)
        {
          //Note: The flip-image-button is already hidden (several lines above, earlier in this function)

          //Then show the flip image button because this image has a flip side
          $(this).find('#modal-flip-image-button').show();
          //And set its value to the flip side version of this image
          $(this).find('#modal-flip-image-button').attr('data-flipside', possible_flip_side_value);
        }
        else
        {
          $(this).find('#modal-flip-image-button').hide();
        }
    });

    $('#modal-flip-image-button').bind('click', function(){

      if($(this).attr('data-show') == undefined)
      {
        var current_src = $('#modal-gallery .modal-image img').attr('src');
        var new_src = $(this).attr('data-flipside');

        $(this).attr('data-side-1', current_src);
        $(this).attr('data-side-2', new_src);

        $(this).attr('data-show', 'data-side-1');
      }

      if($(this).attr('data-show') == 'data-side-1')
      {
        $('#modal-gallery .modal-image img').attr('src', $(this).attr('data-side-2'));
        $(this).attr('data-show', 'data-side-2');
      }
      else
      {
        $('#modal-gallery .modal-image img').attr('src', $(this).attr('data-side-1'));
        $(this).attr('data-show', 'data-side-1');
      }

      //Resize the modal, based on the new image width and height

      var imageElement = $('#modal-gallery .modal-image img')[0];
      //$('#modal-gallery').loadImage(imageElement.src);

      var newlyLoadedImage = new Image();

      newlyLoadedImage.onload = function(){
        /*
        $('#modal-gallery .modal-image img').css({
            width: this.width,
            height: this.height
        });
        $('#modal-gallery .modal-image img').css({
            width: this.width,
            height: this.height
        });
        */
        //$('#modal-gallery').
      };

      newlyLoadedImage.src = imageElement.src;

      return false;
    });

    // Hide/Show citation on item level view page
    $('.hide_show_citation').bind('click', function(){
      if($(this).parent().find('.hidden_citation').hasClass('invisible'))
      {
        $(this).find('.hide_show_link').html('Hide Citation');
        $(this).parent().find('.hidden_citation').removeClass('invisible');
      }
      else
      {
        $(this).find('.hide_show_link').html('Show Citation');
        $(this).parent().find('.hidden_citation').addClass('invisible');
      }
      return false;
    });

    //Search query inline editing
    $('#edit_query_confirm').tooltip();

    $('#query_inline_edit_button').bind('click', function(){
      $('#echo_query').hide();
      $('#edit_query_form').show();
      $('#edit_query_input').focus();
      setTimeout(function(){
        $('#edit_query_form').addClass('form_visible');
      }, 100);
      return false;
    });

    $('#edit_query_cancel').bind('click', function(){
      $('#echo_query').show();
      $('#edit_query_form').hide();
      $('#edit_query_form').removeClass('form_visible');
      return false;
    });

    $('#edit_query_cancel').bind('click', function(){
      if($('#edit_query_form').hasClass('form_visible'))
      {
        setTimeout(function(){
          //This is a fix for if the user's URL ends in a '#' and they're in Safari.
          //Safari doesn't re-submit the form if the query doesn't change, which is
          //actually kind of smart, but not consistent with the behavior of other browsers.
          $('#edit_query_cancel').click();
        }, 100);
      }
      //Do NOT return false in this function
    });

    $('#edit_query_form').bind('clickoutside', function(){
      if($('#edit_query_form').hasClass('form_visible'))
      {
        $('#edit_query_cancel').click();
      }
    });

    /* Contact and Problem Report Forms */
    // Actions here to slow robots

    $('#commentForm').attr('action', '/contact');
    $('#problemReportForm').attr('action', '/problem_report');


    /*
    //Add infinite-scroll if we're working with a ranged set of results (if #current_result_set_range is present)
    //Note: Temporarily disabled for dev purposes.
    if(false && $('#current_result_set_range').length > 0)
    {
      //If we're working with infinite scroll, hide div.pagination
      $('div.pagination').hide(0);

      $('#search_results ul.thumbnails').infinitescroll({
        loading: {
          finishedMsg : '',
          speed : 'slow',
          msgText     : "",
          img      : "/assets/ajax-loader.gif"
        },
        debug           : false,
        nextSelector    : "div.pagination .next a",
        navSelector     : "div.pagination",
        contentSelector : "#search_results ul.thumbnails",
        itemSelector    : "#search_results ul.thumbnails > li"
        },function(){
          //Each time that a new set of results is retrieved, we'll update #current_result_set_range
          $('#current_result_set_range').html('1 - ' + $('#search_results article.post').length);
      });
    }
    */



  /*
  // stick the secondary_nav on scroll
    var theLoc = $('#secondary_nav .subnav').position().top;
    $(window).scroll(function() {
        if(theLoc >= $(window).scrollTop()+$('.navbar-fixed-top').height()) {
            if($('#secondary_nav .subnav').hasClass('fixed')) {
                $('#secondary_nav .subnav').removeClass('fixed');
				$('#inner-headline-outer').css('margin-bottom', '0px');
            }
        } else {
            if(!$('#secondary_nav .subnav').hasClass('fixed')) {
                $('#secondary_nav .subnav').addClass('fixed');
				$('#inner-headline-outer').css('margin-bottom', '45px');
            }
        }
    }); // end stick
  */


}); // ready
