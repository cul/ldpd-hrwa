jQuery(function($) {

  /*****************
   * GENERAL UI    *
   *****************/

	$('.back_button_link').bind('click', function(){
    window.history.go(-2);
  });

  $('.tabs').tab()

  $('.donothing').click(function (e) {
		alert('this does nothing... yet.');
		return false;
  });
  $('.nofollow').click(function (e) {
		alert('disallowing external (non-cu) clicks for now while testing.');
		return false;
  });
/*
  $('a[data-exitmsg]').click(function () {
		alert($(this).attr('data-exitmsg'));
  });
*/
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
  /* Will phase out above in favor of below to keep classes cleaner */
  $('a[data-target="blank"]').attr('target','_blank');

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
  $('input[name=search_type]').change(function() {
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
  $('#home-tab-content .sort_default').live('click', function() { var c = $('#home-tab-content div.tab-pane ul:not(.no-count)'); $('li',c).tinysort('span.count', {order:"desc"}); });
  $('#home-tab-content .sort_a-z').live('click', function() { var a = $('#home-tab-content div.tab-pane ul'); $('li',a).tinysort('span.alpha_sort', {order:"asc"}); });
  $('#home-tab-content .sort_z-a').live('click', function() { var z = $('#home-tab-content div.tab-pane ul'); $('li',z).tinysort('span.alpha_sort', {order:"desc"}); });

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

	/******************
   * Archive result *
   * hl snippets    *
   ******************/

	var hl_snippets_for_archive_results = $('.archive-result .hl_snippet');
	var num_archive_lines_to_show = 3;
	var current_hl_snippet_line_height = parseInt(hl_snippets_for_archive_results.css('line-height'));
	window.new_max_archive_hl_snippet_container_height = num_archive_lines_to_show * current_hl_snippet_line_height;
	hl_snippets_for_archive_results.css({'max-height' : window.new_max_archive_hl_snippet_container_height + 'px'});

	//$('.result_url').click(function(){
	//	$(this).closest('article').find('.hl_snippet').css({'max-height':''});
	//});

	/********************
   * Find Site Result *
   * hl snippets      *
   ********************/

	// Note: For formatting reason, we use 'height' below rather than 'max-height'
	// because it's important that all find site results are the same height
	var hl_snippets_for_find_site_results = $('.find-site-result .hl_snippet');
	//Check for length of non-whitespace characters.  If 0, then we have no snippets to work with:
	var num_find_site_lines_to_show = (hl_snippets_for_find_site_results.first().text().replace(/\s/g,'').length > 0) ? 3 : 0;
	var current_hl_snippet_line_height = parseInt(hl_snippets_for_find_site_results.css('line-height'));
	window.new_max_find_site_hl_snippet_container_height = num_find_site_lines_to_show * current_hl_snippet_line_height;
	hl_snippets_for_find_site_results.css({'height' : window.new_max_find_site_hl_snippet_container_height + 'px'});

	/*********************
   * Extra JS Info For *
   * Problem Reports   *
   *********************/

	var problem_report_hidden_field_html = '';
  problem_report_hidden_field_html += '<input type="hidden" name="problem_report[Referrer]" value="' + (document.referrer == '' ? 'None' : document.referrer) + '" />';
  problem_report_hidden_field_html += '<input type="hidden" name="problem_report[AppCodeName]" value="' + navigator.appCodeName + '" />';
  problem_report_hidden_field_html += '<input type="hidden" name="problem_report[AppName]" value="' + navigator.appName + '" />';
  problem_report_hidden_field_html += '<input type="hidden" name="problem_report[AppVersion]" value="' + navigator.appVersion + '" />';
  problem_report_hidden_field_html += '<input type="hidden" name="problem_report[CookiesEnabled]" value="' + navigator.cookieEnabled + '" />';
  problem_report_hidden_field_html += '<input type="hidden" name="problem_report[Platform]" value="' + navigator.platform + '" />';
  problem_report_hidden_field_html += '<input type="hidden" name="problem_report[UserAgent]" value="' + navigator.userAgent + '" />';

	$('#problemReportForm').append(problem_report_hidden_field_html);

	/*******************
   * Form actions    *
   * inserted using  *
   * JavaScript to   *
   * deter robots    *
   *******************/

	$('#commentForm').attr('action', '/contact');
	$('#problemReportForm').attr('action', '/problem_report');
	$('#frmOwnerNomination').attr('action', '/owner_nomination');
	$('#frmPublicNomination').attr('action', '/public_nomination');

  /******************
   * HRWA Date      *
   * Picker Stuff   *
   ******************/

  //Define the hrwadatepicker creation function
  //Note: This is only meant to be used on input[type="text"] elements
  jQuery.fn.hrwadatepicker = function(params) {

    var mm_placeholder = '- MM -';
    var yyyy_placeholder = '- YYYY -';

    //First, grab a reference to the jquery selector that this function was used on
    var o = $(this[0]);

    //Using the each function just in case the selector brings in multiple items
    o.each(function(){

        var minYear = params.minYear;
        var maxYear = params.maxYear;
        var miniButtons = params.miniButtons ? params.miniButtons : false;

        //By default, set selectedDate to null
        var selectedDate = null;
        //But if a valid date already exists in the input, use it
        //Note: We have to convert the month to month-1 because the new Date() constructor uses zero-indexed months
        var dateInInput = $(this).val();

        if(dateInInput != '' && dateInInput.search(/^\d{4}-\d{2}$/) != -1 )
        {
            selectedDate = new Date(parseInt(dateInInput.substring(0, dateInInput.indexOf("-"))), parseInt(dateInInput.substring(dateInInput.indexOf("-")+1, dateInInput.length))-1, 1);
        }

        var selectedYear = selectedDate != null ? selectedDate.getFullYear() : -1;

        //Note: The month in a date is zero-indexed (so 0 == January and 1 == February)
        var selectedMonth = selectedDate != null ? selectedDate.getMonth()+1 : -1;
        //Note: At this point, the selected month does NOT have a leading 0

        var yearSelectOptionHtml = '';
        for(var i = minYear; i <= maxYear; i++)
        {
            if(i == selectedYear)
            {
                yearSelectOptionHtml += '<option selected="selected" val="'+i+'">'+i+'</option>';
            }
            else
            {
                yearSelectOptionHtml += '<option val="'+i+'">'+i+'</option>';
            }
        }

        var month_number_to_month_data = {
            1 : ['01', 'Jan'],
            2 : ['02', 'Feb'],
            3 : ['03', 'Mar'],
            4 : ['04', 'Apr'],
            5 : ['05', 'May'],
            6 : ['06', 'Jun'],
            7 : ['07', 'Jul'],
            8 : ['08', 'Aug'],
            9 : ['09', 'Sep'],
            10 : ['10', 'Oct'],
            11 : ['11', 'Nov'],
            12 : ['12', 'Dec']
        }
        var monthSelectOptionHtml = '';
        for(var j = 1; j <= 12; j++)
        {
            if(j == selectedMonth)
            {
                monthSelectOptionHtml += '<option selected="selected" val="'+month_number_to_month_data[j][0]+'">'+month_number_to_month_data[j][1]+'</option>';
            }
            else
            {
                monthSelectOptionHtml += '<option val="'+month_number_to_month_data[j][0]+'">'+month_number_to_month_data[j][1]+'</option>';
            }
        }

        //Wrap this input in a div
        $(this).wrap('<span class="hrwadatepicker_wrapper" />');

        var hrwaDatePickerHtml =
        '<span style="display:none;padding-bottom:10px;" class="hrwadatepicker_selects form-inline pull-right-important">'+
            '<select ' + (miniButtons ? 'style="height:28px;" ' : '') + ' class="month span1">'+
                '<option val=""' + ($(this).val() == '' ? ' selected="selected"' : '') + '>' + mm_placeholder + '</option>' +
                monthSelectOptionHtml +
            '</select>' +
            '<select ' + (miniButtons ? 'style="height:28px;" ' : '') + ' class="year span1">'+
                '<option val=""' + ($(this).val() == '' ? ' selected="selected"' : '') + '>' + yyyy_placeholder + '</option>' +
                yearSelectOptionHtml +
            '</select> '+
        '</span>';

        $(this).parent().append(hrwaDatePickerHtml);

        //Show newly added html, hide original input
        $(this).parent().children('.hrwadatepicker_selects').first().css({
            'display' : 'block',
            'width'   : '100%'
        });
        $(this).addClass('invisible');

        $(this).parent().children('.hrwadatepicker_selects').children('select').css({'width' : '50%'}).bind('change', function(){
            var month_name_to_number = {
                'Jan' : '01',
                'Feb' : '02',
                'Mar' : '03',
                'Apr' : '04',
                'May' : '05',
                'Jun' : '06',
                'Jul' : '07',
                'Aug' : '08',
                'Sep' : '09',
                'Oct' : '10',
                'Nov' : '11',
                'Dec' : '12'
            }

            var year_select_value = $(this).parent().children('select.year').val();

            var month_name_select_value = $(this).parent().children('select.month').val();
            var month_select_value = '01';
            if(month_name_select_value == mm_placeholder)
            {
                  month_name_select_value = '01';
            }
            else
            {
                  month_select_value = month_name_to_number[month_name_select_value];
            }

            var date_val = '';

            if(year_select_value != '- YYYY -')
            {
                date_val = year_select_value+'-'+month_select_value;
            }
            else {

            }

            $(this).parent().parent().children('input').val(date_val);

        });

    });
  };

  $(".hrwadatepicker_start").hrwadatepicker({
	  minYear: 2008,
	  maxYear: new Date().getFullYear(),
  });

  $(".hrwadatepicker_end").hrwadatepicker({
	  minYear: 2008,
	  maxYear: new Date().getFullYear(),
  });


  /******************
   * Sidebar Facet  *
   * Modifications  *
   ******************/

  /* --- Date of Capture */
  $('#facets.archive .sb_widget h6:contains(Date Of Capture)').siblings('ul').append(
	(
	  (HRWA.capture_start_date_value != '' || HRWA.capture_end_date_value != '') ?

	  '<li>' +
		(HRWA.capture_end_date_value == '' ? 'After ' + HRWA.capture_start_date_value : (HRWA.capture_start_date_value == '' ? '' : HRWA.capture_start_date_value + ' to ')) +
		(HRWA.capture_start_date_value == '' ? 'Before ' + HRWA.capture_end_date_value : HRWA.capture_end_date_value) +
        ' (' + ($('#search_result_count').length > 0 ? $('#search_result_count').attr('data-actual-result-count') : '0') + ') ' +
		'<a class="remove post_pageload_tooltip" rel="tooltip" data-original-title="Remove this filter" href="' + HRWA.current_url_without_capture_date_params + '">[x]</a>' +
	  '</li>'

	  : ''
	) +
    '<li>' +
		'<span id="date_of_cap_custom_range_container">' +
			'<a id="date_of_cap_custom_range_link" class="post_pageload_tooltip lime" rel="tooltip" data-original-title="Filter by a custom date range" href="#">custom range &raquo;</a>' +
			'<span id="date_of_cap_custom_range_input_container" class="invisible">' +
				'<div><label>Start Date:</label><input class="span2" type="text" id="capture_start_date_sidebar" name="capture_start_date_sidebar" value="' + HRWA.capture_start_date_value + '"/></div>' +
				'<div><label>End Date:</label><input class="span2" type="text" id="capture_end_date_sidebar" name="capture_end_date_sidebar" value="' + HRWA.capture_end_date_value + '"/></div>' +
				'<div class="pull-right"><a href="#" class="btn btn-mini cancel">Cancel</a> <a href="#" class="btn btn-mini btn-success submit">Search</a></div>' +
			    '<div class="clear"></div>' +
			'</span>' +
			'<span class="clearfix"></span>' +
		'<span>' +
	'</li>'
  );
  //Manually add js twipsy tooltips to the recently added anchor tags
  $('.post_pageload_tooltip').tooltip();
  //Add the mini sidebar date chooser when the #date_of_cap_custom_range_link is clicked
  $('#date_of_cap_custom_range_link').bind('click', function(){
	$('#date_of_cap_custom_range_link').addClass('invisible');
	$('#date_of_cap_custom_range_input_container').removeClass('invisible');
	return false;
  });
  $('#date_of_cap_custom_range_input_container').find('.btn.cancel').bind('click', function(){
    $('#date_of_cap_custom_range_link').removeClass('invisible');
	$('#date_of_cap_custom_range_input_container').addClass('invisible');
	$(this).parent().children('input').val('');
	return false;
  });
  $('#date_of_cap_custom_range_input_container').find('.btn.submit').bind('click', function(){
    window.location = HRWA.current_url_without_capture_date_params +
		'&capture_start_date=' + $('#date_of_cap_custom_range_input_container').find('#capture_start_date_sidebar').val() +
		'&capture_end_date=' + $('#date_of_cap_custom_range_input_container').find('#capture_end_date_sidebar').val();
		return false;
  });
  //Add hrwa datepickers to the two sidebar capture date inputs
  $("#capture_start_date_sidebar").hrwadatepicker({
	  minYear: 2008,
	  maxYear: new Date().getFullYear(),
      miniButtons: true
  });
  $("#capture_end_date_sidebar").hrwadatepicker({
	  minYear: 2008,
	  maxYear: new Date().getFullYear(),
      miniButtons: true
  });

	/**********************
	 * Fix for having two *
	 * of the top search  *
	 * form radio buttons *
	 **********************/

	$('input[name="search_type_mobile_button"]').bind('change', function(){
		var value_of_clicked_input = $(this).val();
		$('input[name="search_type"]').each(function(){
				if($(this).val() == value_of_clicked_input) {
					$(this).click();
				}
		});
	});

	$('input[name="search_type"]').bind('change', function(){
		var value_of_clicked_input = $(this).val();
		$('input[name="search_type_mobile_button"]').each(function(){
				if($(this).val() == value_of_clicked_input) {
					$(this).prop('checked', true);
				}
		});
	});



/*******************************
 * Extended Search Tab Madness *
 * hacky. will redo later      *
 *******************************/
	$('#primary ul.nav-tabs li.active a').live('click', function() {
	if ( $(this).attr('href') == '#extended' ) {
		//alert('extended tab');
		$('#secondary').hide(0);
		$('#primary').removeClass('span9').addClass('span12');
	} else {
		$('#secondary').show(0);
		$('#primary').removeClass('span12').addClass('span9');
    }
    });

}); // ready
