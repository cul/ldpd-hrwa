jQuery(function($) {

  //This handy function came from here:
  //http://stackoverflow.com/questions/273789/is-there-a-version-of-javascripts-string-indexof-that-allows-for-regular-expr
  String.prototype.regexIndexOf = function(regex, startpos) {
	var indexOf = this.substring(startpos || 0).search(regex);
	return (indexOf >= 0) ? (indexOf + (startpos || 0)) : indexOf;
  }

  $('.dropdown-toggle').dropdown()

  $('.tabs').tab()
  $('.carousel').carousel()

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
	return false;
  });

  /* Result item detail hiding/showing logic */

  window.max_height_for_hl_snippets = '52px'; //53px seems to equal two lines worth of text for a 12px font.

  $('.hl_snippet').each(function(){

	if($(this).hasClass('fsf'))
	{
	  $(this).attr('data-show-more-snippet-height', 0);
	}
	else if($(this).hasClass('asf'))
	{
	  $(this).attr('data-show-more-snippet-height', $(this).height());
	}

	$(this).css({'max-height' : window.max_height_for_hl_snippets});
	$(this).attr('data-collapsed-snippet-height', $(this).height());
	$(this).removeClass('invisible');
  });

  $('.toggler').each(function(){
	$(this).attr('data-full-toggle-height', $(this).height());
	$(this).css({'height' : '0px', 'overflow' : 'hidden'});
	$(this).removeClass('invisible');
  });

  $(".toggle_section").attr('data-status', 'less-mode').bind('click', function (e) {

	//Showing hidden items
	if($(this).attr('data-status') == 'less-mode')
	{
	  toggle_item_detail($(this), 'show');
	  $(this).attr('data-status', 'more-mode');
	}
	//Hiding visible items
	else
	{
	  toggle_item_detail($(this), 'hide');
	  $(this).attr('data-status', 'less-mode');
	}

	return false;
  });

  function toggle_item_detail(jquery_element, show_or_hide)
  {
	var animation_time = 350;

	if(show_or_hide == 'show')
	{
	  jquery_element.parent().parent().children('.hl_snippet').each(function(){
	$(this).css({'height' : $(this).height() + 'px'});
	$(this).css({'max-height' : ''});
	$(this).animate({
	  height: $(this).attr('data-show-more-snippet-height') + 'px'
	  },
	animation_time);
	  });
	  jquery_element.parent().children('.toggler').each(function(){

	$(this).animate({
	  height: $(this).attr('data-full-toggle-height') + 'px'
	  },
	animation_time);

	  });

	  jquery_element.text('Show Less-');
	}
	else
	{
	  jquery_element.parent().parent().children('.hl_snippet').each(function(){
	$(this).css({'height' : $(this).height() + 'px'});
	$(this).animate({
	  height: $(this).attr('data-collapsed-snippet-height')
	}, animation_time, function(){
	  $(this).css({'max-height' : window.max_height_for_hl_snippets});
	  $(this).css({'height' : ''});
	});
	  });
	  jquery_element.parent().children('.toggler').each(function(){

	$(this).animate({
	  height: '0px'
	  },
	animation_time);

	  });

	  jquery_element.text('Show More+');
	}

	jquery_element.blur();

  }

  /* scroll to top function */
  function scrollToTop() {
    $('body,html').animate({ scrollTop: 0 }, 800);
  }

  /* Show/hide advanced options */

  //HRWA.current_search_type is determined by which radio button is initially checked
  HRWA.current_search_type = ($('#fsfsearch').attr('checked') == 'checked') ? 'fsf' : 'asf';

  //On page load, place the correct hidden fields in the search form (which starts out in simple search mode)
  moveHiddenSearchFieldsIntoForm(HRWA.current_search_type);

  $('#advo_link').bind('click', function (e) {

    scrollToTop();

    if($('#advanced_options_container').css('display') == 'none') {

      //disable simple search input (#q)
      $('#q').attr('disabled', 'disabled');

      //synch simple -> advanced search inputs
      var multi_q_arr = single_q_to_multi_q($('#q').val());
      //single_q_to_multi_q returns an array of the format:
      //[0] == q_and, [1] == q_phrase, [2] == q_or, [3] == q_exclude
      $('#advanced_options_query .q_and').val(multi_q_arr[0]);
      $('#advanced_options_query .q_phrase').val(multi_q_arr[1]);
      $('#advanced_options_query .q_or').val(multi_q_arr[2]);
      $('#advanced_options_query .q_exclude').val(multi_q_arr[3]);

      if(HRWA.current_search_type == 'asf')
      {
        $('#inside_of_form').append($('#advanced_options_query'));
        $('#inside_of_form').append($('#advanced_options_asf'));
      }
      else
      {
        $('#inside_of_form').append($('#advanced_options_query'));
		$('#inside_of_form').append($('#advanced_options_fsf'));
      }

	  $('#outside_of_form').append($('.hidden_search_fields'));

      $('#advanced_options_container').slideDown(600);
    }
    else
    {
      $('#advanced_options_container').slideUp(600, function(){
		//And then remove any .advanced_options divs when the form closes
		$('#outside_of_form').append($('.advanced_options'));

		moveHiddenSearchFieldsIntoForm(HRWA.current_search_type)

        //enable simple search input (#q)
        $('#q').removeAttr('disabled');
      });
    }

    return false;
  });

  function moveHiddenSearchFieldsIntoForm(search_type)
  {
	$('#outside_of_form').append($('.hidden_search_fields'));

	if(search_type == 'asf')
	{
	  $('#inside_of_form').append($('#hidden_search_fields_asf'));
	}
	else
	{
	  $('#inside_of_form').append($('#hidden_search_fields_fsf'));
	}
  }

  function switchToSearchTypeFSF()
  {
	HRWA.current_search_type = 'fsf';
	if($('#advanced_options_container').css('display') != 'none')
	{
	  //Advanced form is currently visible
	  $('#outside_of_form').append($('#advanced_options_asf'));
	  $('#inside_of_form').append($('#advanced_options_fsf'));
	}
	else
	{
		//Advanced form is NOT visible
		moveHiddenSearchFieldsIntoForm(HRWA.current_search_type);
	}
  }
  function switchToSearchTypeASF()
  {
	HRWA.current_search_type = 'asf';
	if($('#advanced_options_container').css('display') != 'none')
	{
	  //Advanced form is currently visible
	  $('#outside_of_form').append($('#advanced_options_fsf'));
	  $('#inside_of_form').append($('#advanced_options_asf'));
	}
	else
	{
		//Advanced form is NOT visible
		moveHiddenSearchFieldsIntoForm(HRWA.current_search_type);
	}
  }

  $('#fsfsearch').click(function(){
	switchToSearchTypeFSF();
	if(HRWA.current_search_type != 'fsf')
	{
	  switchToSearchTypeFSF();
	}
  });
  $('#asfsearch').click(function(){
	if(HRWA.current_search_type != 'asf')
	{
	  switchToSearchTypeASF();
	}
  });

  /* Advanced form reset */
  //TODO: adv form reset
  $('#advreset').live('click', function(e) {
	//$('.advanced_options_container input[type=text]').val('');
  });

  $('.moreless').live('click', function() {
	  $(this).text(($(this).text() == 'Show Less-') ? 'Show More+' : 'Show Less-');
  });

  /* advanced->simple query form synch */
  //Note: No need to synch the simple query field with the advanced query fields
  //in real time because the advanced fields are never visible when you're in
  //simple mode.

  $('#advanced_options_query .q_and,' +
    '#advanced_options_query .q_phrase,' +
    '#advanced_options_query .q_or,' +
    '#advanced_options_query .q_exclude').bind('keyup blur', function(){

    $('#q').val(
      multi_q_to_single_q(
                            $('#advanced_options_query .q_and').val(),
                            $('#advanced_options_query .q_phrase').val(),
                            $('#advanced_options_query .q_or').val(),
                            $('#advanced_options_query .q_exclude').val()
                          )
    );

  });


  // submit top form
  $('#top_form_submit').bind('click',function(e) {

	var cform = $('#topsearchform');
	cform.submit();
	return false;
  });

  $('a.quicklook').live('click', function() {
	  var permalink = this.href;
	  var url = this.href+' #sdf_table';
	  var dlog = $("#sdf_dialog");
	  if ($("#sdf_dialog").length == 0) {
		  dlog = $('<div id="sdf_dialog" style="font-size:80%;display:hidden"><p>Loading Quicklook...</p></div>').appendTo('body');
	  }

	  // load remote content
	  dlog.load( url);
	  $('#sdf_dialog').dialog({zIndex:10001,title:'HRWA SDF Quicklook [<a class="blue" href="'+permalink+'">permalink</a>]',position:['center',60],width:920,modal:true, close: function(event, ui)
			  { $(this).html('Loading Quicklook...'); }
		  });
	  return false;
  });

  $('a.ccf_quicklook').live('click', function() {
	  var permalink = this.href;
	  var url = this.href+' #crawl_calendar';
	  var dlog = $("#ccf_dialog");
	  if ($("#ccf_dialog").length == 0) {
		  dlog = $('<div id="ccf_dialog" style="font-size:100%;display:hidden"><p>Loading Quicklook...</p></div>').appendTo('body');
	  }

	  // load remote content
	  dlog.load(url);
	  $('#ccf_dialog').dialog({zIndex:10001,title:'HRWA CCF Quicklook [<a class="blue" href="'+permalink+'">permalink</a>]',position:['center',60],width:940,modal:true, close: function(event, ui)
			  { $(this).html('Loading Quicklook...'); }
		  });
	  return false;
  });

  // advanced form dropdown multiselect

  /*
   $('.advanced_options select[multiple=multiple]').multiselect({
	 selectedText: "# of # selected"
   });
   $('.advanced_options select[multiple!="multiple"][id!="search_type_selector"]').multiselect({
	 multiple: false,
	 selectedList: 1,
	 height:'auto'
   });
  */


  // avf stuff

	var hrwaxcoh = $('iframe#x_container').height();
	var hrwaxcow = $('iframe#x_container').width();
	$('iframe#x_container').load(function() {
	  $(this).height(hrwaxcoh).width(hrwaxcow);
	  if ($(this).height() < $(this).contents().height()) {
			  $(this).height($(this).contents().height()+10);
	  }
	  if ($(this).width() < $(this).contents().width()) {
		  $(this).width($(this).contents().width()+20);
	  }
	  $('img.loader').hide();
	  $(this).contents().find('a').click(function() {
		  alert('HRWA detected this click. We\'ll let you proceed :)');
		  $('#avf-infoalert').remove();
		  return true;
	  });
	  if ($('#avf-infoalert').css('visibility','visible')) {
		  $('#avf-infoalert').remove();
		  $('#contentttt').append('<div id="avf-infoalert" class="alert-message"><a href="#" class="close">x</a>You are viewing an archived web page that is part of the Columbia University Libraries <strong>Human Rights Web Archive</strong>. This will be a useful info section. <em>See All versions of this archived page</em>. More useful info here.</div>');
	  }
	});

  // toggle all menu stuff

  //Only show toggle buttons if there's at least one search result
  if($('article.post').length > 0)
  {
	$('.results_control').show();
	$('.toggle_all_btn').attr('data-status', 'less-mode').live('click', function() {
	  if($(this).attr('data-status') == 'less-mode')
	  {
		$(this).attr('data-original-title', 'Collapse All');
		toggle_item_detail($('article.post .toggle_section'), 'show');
		$(this).attr('data-status', 'more-mode');
		$(this).text('Collapse All -');
	  }
	  else
	  {
		$(this).attr('data-original-title', 'Expand All');
		toggle_item_detail($('article.post .toggle_section'), 'hide');
		$(this).attr('data-status', 'less-mode');
		$(this).text('Expand All +');
	  }

	  $(this).blur();
	  return false;
	});
  }

  function sortState(foo) {
    $('.results_control').find('a').removeClass('btn-success');
    foo.addClass('btn-success');
  }

  //for smart cbf showings
  function showControls() {
    //$('.tab-content .results_control .sort_a-z.btn').click().removeClass('btn-success');
    $('#home-tab-content .results_control').show(0, function() {
        if ( $('#home-tab-content div.tab-pane.active ul').hasClass('no-count') ) {
            $(this).find('.sort_default').hide();
        } else {
            $(this).find('.sort_default').show();
        }
      }
    );
  }

  $('#primary .sort_default').live('click', function() { $('article.post').tinysort({attr:"id"}); sortState($(this)); });
  $('#primary .sort_a-z').live('click', function() { $('article.post').tinysort({order:"asc"}); sortState($(this)); });
  $('#primary .sort_z-a').live('click', function() { $('article.post').tinysort({order:"desc"}); sortState($(this)); });

  $('/* #secondary .results_control,*/ #cbf .results_control').prepend('<a class="sort_default btn small" title="Sort by Count">#</a> <a class="sort_a-z btn small" title="Sort by A-Z">A-Z</a> <a class="sort_z-a btn small" title="Sort by Z-A">Z-A</a>');

  // for cbf page
  $('#cbf_widgets .sort_default').live('click', function() { var c = $(this).parent().next('ul'); $('li',c).tinysort('span', {order:"desc"}); sortState($(this)); });
  $('#cbf_widgets .sort_a-z').live('click', function() { var a = $(this).parent().next('ul'); $('li',a).tinysort({order:"asc"}); sortState($(this)); });
  $('#cbf_widgets .sort_z-a').live('click', function() { var z = $(this).parent().next('ul'); $('li',z).tinysort({order:"desc"}); sortState($(this)); });

  // for home cbf tabs
  $('#home-tab-content .sort_default').live('click', function() { var c = $('#home-tab-content div.tab-pane ul:not(.no-count)'); $('li',c).tinysort('span', {order:"desc"}); });
  $('#home-tab-content .sort_a-z').live('click', function() { var a = $('#home-tab-content div.tab-pane ul'); $('li',a).tinysort({order:"asc"}); });
  $('#home-tab-content .sort_z-a').live('click', function() { var z = $('#home-tab-content div.tab-pane ul'); $('li',z).tinysort({order:"desc"}); });

  $('.navbar a[rel=tooltip], .navbar label[rel=tooltip]').tooltip({'placement': 'bottom'});
  $('a[rel=tooltip], .results_control a').tooltip({'placement': 'top'});
  $('article span[rel=tooltip], .hero-unit label[rel=tooltip]').css('cursor','pointer').tooltip({'placement': 'top'});

  // cbf home onload sorting and showing
  $('.tab-content .results_control .sort_a-z.btn').click().removeClass('btn-success');
  $('.tab-content .results_control').not('#home-tab-content .results_control').show();
  showControls();
  $('ul.tabs li a').live('click', function() { showControls(); $(this).blur(); });

  // cbf home column controls
    // will want to clean up.
  $('.tab-content .results_control .sort_col-1').live('click', function() { $('#home-tab-content div.tab-pane > ul').css('-moz-column-count','1').css('-webkit-column-count','1').css('column-count','1'); $(this).parent().parent().find('li.active').removeClass('active'); $(this).parent().addClass('active'); });
  $('.tab-content .results_control .sort_col-2').live('click', function() { $('#home-tab-content div.tab-pane > ul').css('-moz-column-count','2').css('-webkit-column-count','2').css('column-count','2'); $(this).parent().parent().find('li.active').removeClass('active'); $(this).parent().addClass('active'); });
  $('.tab-content .results_control .sort_col-3').live('click', function() { $('#home-tab-content div.tab-pane > ul').css('-moz-column-count','3').css('-webkit-column-count','3').css('column-count','3'); $(this).parent().parent().find('li.active').removeClass('active'); $(this).parent().addClass('active'); });

  // cbf browse onload sorting and showing
  $('#cbf_widgets .results_control .sort_default.btn').first().hide(); //hide # sort, not needed
  $('#cbf_widgets .results_control .sort_a-z.btn').click();
  $('#cbf_widgets .results_control').show();

  // autocomplete
  /*
	  function log( message ) {
		  $( "<div/>" ).text( message ).prependTo( "#primary" );
		  $( "#primary" ).scrollTop( 0 );
	  }

	  $( "#topsearchform" ).autocomplete({
		  source: "inc/autocomplete.php",
		  minLength: 2,
		  select: function( event, ui ) {
			  log( ui.item ?
				  "Selected: " + ui.item.value + " aka " + ui.item.id :
				  "Nothing selected, input was " + this.value );
		  }
	  });
  */

  /* HRWA Date Picker Stuff */

  //Define the hrwadatepicker creation function
  //Note: This is only meant to be used on input[type="text"] elements
  jQuery.fn.hrwadatepicker = function(params) {

    //First, grab a reference to the jquery selector that this function was used on
    var o = $(this[0]);

    //Using the each function just in case the selector brings in multiple items
    o.each(function(){

        var minYear = params.minYear;
        var maxYear = params.maxYear;

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
        '<span style="display:none;" class="hrwadatepicker_selects form-inline">'+
            '<select class="year">'+
                '<option val="YYYY"' + ($(this).val() == '' ? ' selected="selected"' : '') + '>YYYY</option>' +
                yearSelectOptionHtml +
            '</select> '+
            '<select class="month">'+
                '<option val="MM"' + ($(this).val() == '' ? ' selected="selected"' : '') + '>MM</option>' +
                monthSelectOptionHtml +
            '</select>' +
        '</span>';

        $(this).parent().append(hrwaDatePickerHtml);

        //Show newly added html, hide original input
        $(this).parent().children('.hrwadatepicker_selects').first().css({
            'display' : 'inline-block',
            'width'   : $(this).width() + 'px'
        });
        $(this).addClass('invisible');

        $(this).parent().children('.hrwadatepicker_selects').children('select').bind('change', function(){
            var month_name_to_number = {
                'MM'  : 'MM',
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
            var month_select_value = month_name_to_number[$(this).parent().children('select.month').val()];

            if(year_select_value != 'YYYY' && month_select_value != 'MM')
            {
                $(this).parent().parent().children('input').val(year_select_value+'-'+month_select_value);
            }

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

  //Weighting sliders
  $('#url_weight_slider').slider({
		value: $('#url_weight_slider').attr('data-val-from-url') ? parseFloat($('#url_weight_slider').attr('data-val-from-url')) : 1,
		min: 1,
		max: 500,
		step: 1,
		slide: function( event, ui ) {
			$( "#url_weight_label" ).html( "URL: " + ui.value );
			$( "#url_weight" ).val( "originalUrl^" + ui.value );
		}
  });
  $('#page_title_weight_slider').slider({
		value: $('#page_title_weight_slider').attr('data-val-from-url') ? parseFloat($('#page_title_weight_slider').attr('data-val-from-url')) : 1,
		min: 1,
		max: 500,
		step: 1,
		slide: function( event, ui ) {
			$( "#page_title_weight_label" ).html( "Page Title: " + ui.value );
			$( "#page_title_weight" ).val( "contentTitle^" + ui.value );
		}
  });
  $('#page_content_weight_slider').slider({
		value: $('#page_content_weight_slider').attr('data-val-from-url') ? parseFloat($('#page_content_weight_slider').attr('data-val-from-url')) : 1,
		min: 1,
		max: 500,
		step: 1,
		slide: function( event, ui ) {
			$( "#page_content_weight_label" ).html( "Page Content: " + ui.value );
			$( "#page_content_weight" ).val( "contentBody^" + ui.value );
		}
  });
  $( "#url_weight_label" ).html( "URL: " + $( "#url_weight_slider" ).slider( "value" ) );
  $( "#page_title_weight_label" ).html( "Page Title: " + $( "#page_title_weight_slider" ).slider( "value" ) );
  $( "#page_content_weight_label" ).html( "Page Content: " + $( "#page_content_weight_slider" ).slider( "value" ) );
  $( "#url_weight" ).val( 'originalUrl^' + $( "#url_weight_slider" ).slider( "value" ) );
  $( "#page_title_weight" ).val( 'contentTitle^' + $( "#page_title_weight_slider" ).slider( "value" ) );
  $( "#page_content_weight" ).val( 'contentBody^' + $( "#page_content_weight_slider" ).slider( "value" ) );


  /* Sidebar facet modifications */
  /* --- Date of Capture */
  $('#facets.archive .sb_widget h6:contains(Date Of Capture)').siblings('ul').append(
	(
	  ($('#capture_start_date').val() != '' || $('#capture_end_date').val() != '') ?

	  '<li>' +
		($('#capture_end_date').val() == '' ? 'After ' + $('#capture_start_date').val() : ($('#capture_start_date').val() == '' ? '' : $('#capture_start_date').val() + ' to ')) +
		($('#capture_start_date').val() == '' ? 'Before ' + $('#capture_end_date').val() : $('#capture_end_date').val()) +
        ' (' + ($('#search_result_count').length > 0 ? $('#search_result_count').html() : '0') + ') ' +
		'<a class="remove post_pageload_tooltip" rel="tooltip" data-original-title="Remove this filter" href="' + HRWA.current_url_without_capture_date_params + '">[x]</a>' +
	  '</li>'

	  : ''
	) +
    '<li>' +
		'<span id="date_of_cap_custom_range_container">' +
			'<a id="date_of_cap_custom_range_link" class="post_pageload_tooltip" rel="tooltip" data-original-title="Filter by a custom date range" href="#">Custom range...</a>' +
			'<span id="date_of_cap_custom_range_input_container" class="invisible">' +
				'<div><label>Start Date:</label><input class="span2" type="text" id="capture_start_date_sidebar" name="capture_start_date_sidebar" /></div>' +
				'<div><label>End Date:</label><input class="span2" type="text" id="capture_end_date_sidebar" name="capture_end_date_sidebar" /></div>' +
				'<a href="#" class="btn btn-small cancel">Cancel</a><a href="#" class="btn btn-small submit">Search</a>' +
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
  });
  $('#date_of_cap_custom_range_input_container').find('.btn.cancel').bind('click', function(){
    $('#date_of_cap_custom_range_link').removeClass('invisible');
	$('#date_of_cap_custom_range_input_container').addClass('invisible');
	$(this).parent().children('input').val('');
  });
  $('#date_of_cap_custom_range_input_container').find('.btn.submit').bind('click', function(){
    window.location = HRWA.current_url_without_capture_date_params +
		'&capture_start_date=' + $(this).parent().find('input[name="capture_start_date_sidebar"]').val() +
		'&capture_end_date=' + $(this).parent().find('input[name="capture_end_date_sidebar"]').val();
  });
  //Add hrwa datepickers to the two sidebar capture date inputs
  $("#capture_start_date_sidebar").hrwadatepicker({
	  minYear: 2008,
	  maxYear: new Date().getFullYear(),
  });
  $("#capture_end_date_sidebar").hrwadatepicker({
	  minYear: 2008,
	  maxYear: new Date().getFullYear(),
  });


  /* Round-trip parsing functions */

  // reverse parse advanced form inputs to q
  function adv_to_q() {
	return;
   if ($('#q').val() == '') {
	var erq_and = ($('#q_and').val() != '') ? $('#q_and').val().replace(/^|\s(?=[^ ])/g, ' +').trim() : '';
	var erq_exclude = ($('#q_exclude').val() != '') ? $('#q_exclude').val().replace(/^|\s(?=[^ ])/g, ' -').trim() : '';
	var erq_or = ($('#q_or').val() != '') ? $('#q_or').val().replace(/^|\s/g, ' ').trim() : '';
	var erq_phrase = ($('#q_phrase').val() != '') ? '"'+$('#q_phrase').val()+'"' : '';
	var ssval = erq_and + ' ' + erq_exclude + ' ' + erq_phrase + ' ' + erq_or;
	$('#q').val(ssval);
	//$('#q_echo').html(ssval);
   }
  }
  // reverse parse q to advanced form inputs
  function q_to_adv() {
   if($('#q_phrase').val() == '') {
	var erq_to_q_phrase = ( $('#q').val().match(/".*"/g) ) ? $('#q').val().match(/".*"/g).join('').replace(/"/g,'').trim() : '';
	$('#q_phrase').val(erq_to_q_phrase);
   }
   if($('#q_and').val() == '') {
	var erq_to_q_and = ( $('#q').val().match(/\+[A-Za-z0-9]+\s?/g) ) ? $('#q').val().match(/\+[A-Za-z0-9]+\s?/g).join('').replace(/\+/g,'').trim() : '';
	$('#q_and').val(erq_to_q_and);
   }
   if($('#q_exclude').val() == '') {
	var erq_to_q_exclude = ( $('#q').val().match(/\-[A-Za-z0-9]+\s?/g) ) ? $('#q').val().match(/\-[A-Za-z0-9]+\s?/g).join('').replace(/\-/g,'').trim() : '';
	$('#q_exclude').val(erq_to_q_exclude);
   }
   if($('#q_or').val() == '') {
	var erq_to_q_or = ( $('#q').val().match(/(^|\s)+[A-Za-z0-9]+(?=([^"]*"[^"]*")*[^"]*$)/g) ) ? $('#q').val().match(/(^|\s)+[A-Za-z0-9]+(?=([^"]*"[^"]*")*[^"]*$)/g).join('').trim() : '';
	$('#q_or').val(erq_to_q_or);
   }
  }

  function multi_q_to_single_q(q_and, q_phrase, q_or, q_exclude)
  {
	var new_q_and_string = '';
	var new_q_phrase_string = '';
	var new_q_or_string = '';
	var new_q_exclude_string = '';

	//Remove extra whitespace as needed, split on spaces for non-q_phrase fields

	if(q_and.length > 0)
	{
	  var quoted_q_and_to_append = '';

	  //q_and is a special case because I'm also allowing quotes to be used here
	  //This is an overflow area for multiple quoted items
	  //First we need to separate all quoted strings and
	  //then we'll add them at the end in the format "some string"
	  //This allows a user to have multi word q_and strings
	  var quoted_item_regex = /"([^"\\]*(\\.[^"\\]*)*)"/g;
	  var q_and_quoted_items_arr = q_and.match(quoted_item_regex);
	  if(q_and_quoted_items_arr != null)
	  {
		q_and = q_and.replace(quoted_item_regex, ''); //update a_and, removing quoted_item occurrences
		quoted_q_and_to_append = ' +' + q_and_quoted_items_arr.join(' +');
	  }

	  var q_and_arr = $.trim(q_and).replace(/\s+/g, ' ').split(' '); //trim, q_and, convert multi-spaces into single spaces, and split on single spaces
	  new_q_and_string = '+' + q_and_arr.join(' +');
	  new_q_and_string = new_q_and_string + quoted_q_and_to_append + ' '; //extra space after for formatting
	}

	if(q_phrase.length > 0)
	{
	  var q_phrase_val = $.trim(q_phrase); //we don't split q_phrase on spaces
	  new_q_phrase_string = '"' + q_phrase_val + '"';
	  new_q_phrase_string = new_q_phrase_string + ' '; //extra space after for formatting
	}

	if(q_or.length > 0)
	{
	  var q_or_arr = $.trim(q_or).split(' ');
	  new_q_or_string = q_or_arr.join(' ');
	  new_q_or_string = new_q_or_string + ' '; //extra space after for formatting
	}

	if (q_exclude.length > 0)
	{
	  var q_exclude_arr = $.trim(q_exclude).split(' ');
	  new_q_exclude_string = '-' + q_exclude_arr.join(' -');
	  //no extra space after q_exclude because it's the last item in the concatenated string!
	}

	return $.trim(new_q_and_string + new_q_phrase_string + new_q_or_string + new_q_exclude_string);
  }

  /**
   * Returns a four element array with each element corresponding to
   * one of the multi q items.
   * [0] == q_and, [1] == q_phrase, [2] == q_or, [3] == q_exclude
   *
   * NOTE: I'm assuming that for q_phrase quoted items, the user will ALWAYS
   * use double quotes.  We should probably write a note or search tip to
   * let them know about this functionality.  Single quotes could also be
   * mistaken for apostrophes, so in the end it's better to only use double
   * quotes for p_hrase anyway.
   * This seems like a fair thing to expect/enforce for simple q searches.
   */
  function single_q_to_multi_q(q)
  {
	var i = 0; //counter -- used later

	//If q is empty, just return four empty values
	if(q == "")
	{
	  return ['', '', '', ''];
	}

	var q_and_arr = null;
	var q_phrase_arr = null;
	var q_exclude_arr = null;

	var parsed_q_and = '';
	var parsed_q_phrase = '';
	var q_or_value = '';
	var parsed_q_exclude = '';

	//We'll be parsing from left to right, but we can't assume that combined q
	//presents and, phrase, or and exclude values in any particular order.

	//It would probably be easiest if we remove quoted q phrase values first

	var q_phrase_regex = /"([^"\\]*(\\.[^"\\]*)*)"/g;
	var q_phrase_arr = q.match(q_phrase_regex);
	if(q_phrase_arr != null)
	{
	  //We're only remove leading and trailing quotation marks on the FIRST
	  //element in the array because all other elements will be going into
	  //q_or later on, so quotation marks need to be retained there.
	  q = q.replace(q_phrase_regex, ''); //update q, removing q_phrase occurrences
	  parsed_q_phrase = q_phrase_arr[0].substring(1, q_phrase_arr[0].length-1);
	}

	//TODO: Figure out what to do if a user types in multiple quotes strings.
	//For now, I'm removing all of them and putting them into q_phrase_arr,
	//but our advanced form only allows a user to enter a single "exact wording
	// or phrase".  This isn't a javascript limitation, but rather, a limit in
	//the ability of the advanced search form.
	//
	//In order to allow multi-exact-phrase searches to work, I'm following Google's
	//advanced form model and I'm placing the first item in q_phrase_arr in
	//parsed_q_phrase, but placing all subsequent elements directly in parsed_q_and
	//because quoted items in q_and should behave the same way as a single quoted
	//item in the q_phrase field.

	//Now that we've removed the q_phrase items from q, the rest of the parsing should be easier

	//Let's remove any word in q that is preceeded by ' -' (space followed by a minus sign)
	//We'll also be doing a removal if q starts with a minus followed immediately by text

	var q_exclude_regex = /(^-[^\s]+)|(\s-[^\s]+)/g;
	var q_exclude_arr = q.match(q_exclude_regex);
	if(q_exclude_arr != null)
	{
	  //Remove leading minus sign
	  for(i = 0; i < q_exclude_arr.length; i++)
	  {
		q_exclude_arr[i] = $.trim(q_exclude_arr[i]).substring(1, q_exclude_arr[i].length);
	  }
	  q = q.replace(q_exclude_regex, ''); //update q, removing q_exclude occurrences
	  parsed_q_exclude = q_exclude_arr.join(' ');
	}

	//Let's remove any word in q that is preceeded by ' +' (space followed by a plus sign)
	//We'll also be doing a removal if q starts with a plus followed immediately by text

	var q_and_regex = /(^\+[^\s]+)|(\s\+[^\s]+)/g;
	var q_and_arr = q.match(q_and_regex);
	if(q_and_arr != null)
	{
	  //Remove leading plus sign
	  for(i = 0; i < q_and_arr.length; i++)
	  {
		q_and_arr[i] = $.trim(q_and_arr[i]).substring(1, q_and_arr[i].length);
	  }
	  q = q.replace(q_and_regex, ''); //update q, removing q_exclude occurrences
	  parsed_q_and = q_and_arr.join(' ');
	}

	/*
	//TODO: Un-comment this out later

	//We'll also add any additional q_phrase_arr items to q_and so that they
	//still apply to the search
	if(q_phrase_arr != null && q_phrase_arr.length > 1)
	{
	  for(i = 1; i < q_phrase_arr.length; i++)
	  parsed_q_and += ' ' + q_phrase_arr[i];
	}
	parsed_q_and = $.trim(parsed_q_and); //remove leading and trailing whitespace
	*/

	//Whatever's left in the string can be placed in q_or.  But we'll need to
	//compress multi-spaces into single spaces.  The extra spaces appear as a
	//result of the earlier replace operations.
	var parsed_q_or = $.trim(q).replace(/\s+/g, ' '); //this is whatever remains in q after everything else has been removed

	return new Array(parsed_q_and, parsed_q_phrase, parsed_q_or, parsed_q_exclude);
  }

  // Warn users that the submit bug report link on the bottom doesn't currently work
  $('#submit_bug_report_link').bind('click', function(){
	alert('Bug reporting by public users is not yet implemented. You will now be redirected to the internal feedback form.');
  });

}); // ready
