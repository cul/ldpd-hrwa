jQuery(function($) {

  //This handy function came from here:
  //http://stackoverflow.com/questions/273789/is-there-a-version-of-javascripts-string-indexof-that-allows-for-regular-expr
  String.prototype.regexIndexOf = function(regex, startpos) {
	var indexOf = this.substring(startpos || 0).search(regex);
	return (indexOf >= 0) ? (indexOf + (startpos || 0)) : indexOf;
  }


  // Dropdown example for topbar nav
  // ===============================

/* //using bootstrap-dropdown.js now
  $("body").bind("click", function (e) {
    $('a.menu').parent("li").removeClass("open");
  });

  $("a.menu").click(function (e) {
    var $li = $(this).parent("li").toggleClass('open');
    return false;
  });
*/
  $('.topbar').dropdown()

  $('.tabs').tabs()

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

  /* Start -- Result item hiding/showing logic */

  window.max_height_for_hl_snippets = '53px'; //53px seems to equal two lines worth of text for a 12px font.

  $('.hl_snippet').each(function(){
    $(this).attr('data-full-snippet-height', $(this).height());
    $(this).css({'max-height' : window.max_height_for_hl_snippets});
    $(this).attr('data-collapsed-snippet-height', $(this).height());
    $(this).removeClass('invisible');
  });

  $('.toggler').each(function(){
    $(this).attr('data-full-toggle-height', $(this).height());
    $(this).css({'height' : '0px', 'overflow' : 'hidden'});
    $(this).removeClass('invisible');
  });


  $(".toggle_section").bind('click', function (e) {

	//Showing hidden items
	if($(this).parent().parent().children('.hl_snippet').css('max-height') == window.max_height_for_hl_snippets)
	{
	  toggle_item_detail($(this), 'show');
	}
	//Hiding visible items
	else
	{
	  toggle_item_detail($(this), 'hide');
	}

	return false;
  });

  function toggle_item_detail(jquery_element, show_or_hide)
  {
    var animation_time = 500;

    if(show_or_hide == 'show')
    {
      jquery_element.parent().parent().children('.hl_snippet').each(function(){
	$(this).css({'height' : $(this).height() + 'px'});
	$(this).css({'max-height' : ''});
	$(this).animate({
	  height: $(this).attr('data-full-snippet-height') + 'px'
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

  /* End -- Result item hiding/showing logic */

  /* Simple/advanced form logic */

  window.search_type = $('#searchform').attr('data-searchtype-onload') == 'archive' ? 'archive' : 'find_site';
  showSimpleSearch(); //immediately when the page loads

  function showSimpleSearch()
  {
    $('.advanced_options').appendTo('#outside_of_form');

    $('#s_type_selector_and_submit').appendTo('#simple_options .submit_button_container');
    $('#simple_options').appendTo('#inside_of_form');

    adv_to_q();
    $('#advo_link').text('Adv+');
  }

  function showAdvancedSearch(s_type)
  {
    $('#simple_options').appendTo('#outside_of_form');
    $('.advanced_options').appendTo('#outside_of_form'); //This is necessary for switching straight from advanced_asf mode to advanced_fsf mode.

    if(s_type == 'archive')
    {
      $('#s_type_selector_and_submit').appendTo('#advanced_options_asf .submit_button_container');
      $('#advanced_options_asf').appendTo('#inside_of_form');
    }
    else
    {
      $('#s_type_selector_and_submit').appendTo('#advanced_options_fsf .submit_button_container');
      $('#advanced_options_fsf').appendTo('#inside_of_form');
    }

    q_to_adv();
    $('#advo_link').text('Adv-');
  }

  $('#advo_link').bind('click', function (e) {

	if($('#simple_options').parent().attr('id') == 'inside_of_form')
	{
	  var current_search_type = $('#fsfsearch').attr('checked') == 'checked' ? 'find_site' : 'archive';
	  showAdvancedSearch(current_search_type);
	}
	else
	{
	  showSimpleSearch();
	}

	$(this).blur();
	return false;
  });

  $('#fsfsearch').click(function(){
    if($('#advanced_options_fsf').parent().attr('id') == 'outside_of_form' && $('#advanced_options_asf').parent().attr('id') == 'inside_of_form')
    {
      showAdvancedSearch('find_site');
    }
  });

  $('#asfsearch').click(function(){
    if($('#advanced_options_asf').parent().attr('id') == 'outside_of_form' && $('#advanced_options_fsf').parent().attr('id') == 'inside_of_form')
    {
      showAdvancedSearch('archive');
    }
  });


  //

  $('#advsubmit').live('click', function(e) {

    /*
    if ($('#q_and').val() != '' || $('#q_phrase').val() != '' || $('#q_or').val() != '' || $('#q_exclude').val() != '') {
        if ($('#q_and').val() != '') { var q_and = '+'+$('#q_and').val(); } else { var q_and = ''; }
        if ($('#q_phrase').val() != '') { var q_phrase = ' "'+$('#q_phrase').val()+'" '; } else { var q_phrase = ' '; }
        if ($('#q_or').val() != '') { var q_or = $('#q_or').val()+' '; } else { var q_or = ' '; }
        if ($('#q_exclude').val() != '') { var q_exclude = '-'+$('#q_exclude').val(); } else { var q_exclude = ''; }
        var newaq = q_and.replace(/ /g,' +')+q_phrase+q_or+q_exclude.replace(/ /g,' -');
        //$('#q').val(newaq.replace(/"/g, "&quot;").replace(/'/g, "&#039;"));
        $('#q, #q_t').val(newaq);
    }
    */
    $('#searchform').submit();
  });
  $('#advreset').live('click', function(e) {
	$('.advanced_options input[type=text]').val('');
  });

  $('.submitss').parent().css('visibility','visible');
  $('.submitss').live('click', function (e) {
	var cform = $(this).closest('form');
	cform.submit();
	return false;
  });

$('.moreless').live('click', function() {
    $(this).text(($(this).text() == 'Show Less-') ? 'Show More+' : 'Show Less-');
});

// resubmit
$('.submit_topsearch').live('click',function(e) {
	$('#topsearchform').submit();
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
    dlog.load( url);
    $('#ccf_dialog').dialog({zIndex:10001,title:'HRWA CCF Quicklook [<a class="blue" href="'+permalink+'">permalink</a>]',position:['center',60],width:940,modal:true, close: function(event, ui)
            { $(this).html('Loading Quicklook...'); }
        });
    return false;
});

// advanced form dropdown multiselect
 $('.advanced_options select[multiple=multiple]').multiselect({
   selectedText: "# of # selected"
 });
 $('.advanced_options select[multiple!="multiple"][id!="search_type_selector"]').multiselect({
   multiple: false,
   selectedList: 1,
   height:'auto'
 });

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

// sorting
// toggle all menu stuff

$('.tab-content .results_control').show();

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
$('.results_control').find('a').removeClass('success');
foo.addClass('success');
}
$('#primary .sort_default').live('click', function() { $('article.post').tinysort({attr:"id"}); sortState($(this)); });
$('#primary .sort_a-z').live('click', function() { $('article.post').tinysort({order:"asc"}); sortState($(this)); });
$('#primary .sort_z-a').live('click', function() { $('article.post').tinysort({order:"desc"}); sortState($(this)); });

$('/* #secondary .results_control,*/ #cbf .results_control').prepend('<a class="sort_default btn small" title="Sort by Count">#</a> <a class="sort_a-z btn small" title="Sort by A-Z">A-Z</a> <a class="sort_z-a btn small" title="Sort by Z-A">Z-A</a>');
$('#cbf .results_control:first .sort_default').hide();
$('.sort_default').live('click', function() { var c = $(this).parent().next('ul'); $('li',c).tinysort('span', {order:"desc"}); sortState($(this)); });
$('.sort_a-z').live('click', function() { var a = $(this).parent().next('ul'); $('li',a).tinysort({order:"asc"}); sortState($(this)); });
$('.sort_z-a').live('click', function() { var z = $(this).parent().next('ul'); $('li',z).tinysort({order:"desc"}); sortState($(this)); });
$('#cbf .results_control:first').parent().find('.sort_a-z').trigger('click');

$('a[rel=twipsy], .results_control a').twipsy({'placement': 'above'});
$('article span[rel=twipsy]').css('cursor','pointer').twipsy({'placement': 'above'});
$('.topbar a[rel=twipsy]').twipsy({'placement': 'right'});

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

$( ".datepicker" ).datepicker({
	minDate: new Date(2008, 1, 1),
	gotoCurrent: true,
	changeMonth: true,
	changeYear: true,
	dateFormat: "yymm"
});

// reverse parse advanced form inputs to q
function adv_to_q() {
  return;
 if ($('#q').val() == '') {
  var erq_and = ($('.q_and').val() != '') ? $('.q_and').val().replace(/^|\s(?=[^ ])/g, ' +') : '';
  var erq_exclude = ($('.q_exclude').val() != '') ? $('.q_exclude').val().replace(/^|\s(?=[^ ])/g, ' -') : '';
  var erq_or = ($('.q_or').val() != '') ? $('.q_or').val().replace(/^|\s/g, ' ') : '';
  var erq_phrase = ($('.q_phrase').val() != '') ? '"'+$('.q_phrase').val()+'"' : '';
  $('#q').val(erq_and + ' ' + erq_exclude + ' ' + erq_phrase + ' ' + erq_or)
 }
}
// reverse parse q to advanced form inputs
function q_to_adv() {
  return;
 if($('.q_phrase').val() == '') {
  var erq_to_q_phrase = ( $('#q').val().match(/".*"/g) ) ? $('#q').val().match(/".*"/g).join('').replace(/"/g,'') : '';
  $('.q_phrase').val(erq_to_q_phrase);
 }
 if($('.q_and').val() == '') {
  var erq_to_q_and = ( $('#q').val().match(/\+[A-Za-z0-9]+\s?/g) ) ? $('#q').val().match(/\+[A-Za-z0-9]+\s?/g).join('').replace(/\+/g,'') : '';
  $('.q_and').val(erq_to_q_and);
 }
 if($('.q_exclude').val() == '') {
  var erq_to_q_exclude = ( $('#q').val().match(/\-[A-Za-z0-9]+\s?/g) ) ? $('#q').val().match(/\-[A-Za-z0-9]+\s?/g).join('').replace(/\-/g,'') : '';
  $('.q_exclude').val(erq_to_q_exclude);
 }
 if($('.q_or').val() == '') {
  var erq_to_q_or = ( $('#q').val().match(/(^|\s)+[A-Za-z0-9]+(?=([^"]*"[^"]*")*[^"]*$)/g) ) ? $('#q').val().match(/(^|\s)+[A-Za-z0-9]+(?=([^"]*"[^"]*")*[^"]*$)/g).join('') : '';
  $('.q_or').val(erq_to_q_or);
 }
}

//On page load, properly fill in the simple form
if(HRWA.q == "")
{
  //If q has a value, use that value for q.  Otherwise use the combined q_and, q_phrase, q_or and q_exclude
  HRWA.q = multi_q_to_single_q(HRWA.q_and, HRWA.q_phrase, HRWA.q_or, HRWA.q_exclude);
}
$('#simple_options #q').val(HRWA.q);


function sync_all_forms(form_to_mirror) {

  var sync_to_simple_form = false;
  var sync_to_advanced_fsf_form = false;
  var sync_to_advanced_asf_form = false;

  if(form_to_mirror == 'simple')
  {
	//generate new q based on simple form content
	HRWA.q = $('#simple_options #q').val();
	//generate new q_and, q_phrase, q_or, q_exclude based on q
	var multi_q_arr = single_q_to_multi_q(HRWA.q);

	//single_q_to_multi_q returns an array of the format:
	//[0] == q_and, [1] == q_phrase, [2] == q_or, [3] == q_exclude

	HRWA.q_and = multi_q_arr[0];
	HRWA.q_phrase = multi_q_arr[1];
	HRWA.q_or = multi_q_arr[2];
	HRWA.q_exclude = multi_q_arr[3];

	sync_to_advanced_fsf_form = true;
	sync_to_advanced_asf_form = true;
  }
  else if(form_to_mirror == 'advanced_fsf') {

	//generate new q_and, q_phrase, q_or, q_exclude based on advanced_fsf form content
	HRWA.q_and = $('#advanced_options_fsf .q_and').val();
	HRWA.q_phrase = $('#advanced_options_fsf .q_phrase').val();
	HRWA.q_or = $('#advanced_options_fsf .q_or').val();
	HRWA.q_exclude = $('#advanced_options_fsf .q_exclude').val();
	//generate new q based on q_and, q_phrase, q_or, q_exclude
	HRWA.q = multi_q_to_single_q(HRWA.q_and, HRWA.q_phrase, HRWA.q_or, HRWA.q_exclude);

	sync_to_simple_form = true;
	sync_to_advanced_asf_form = true;
  }
  else if(form_to_mirror == 'advanced_asf') {
	//generate new q_and, q_phrase, q_or, q_exclude based on advanced_asf form content
	HRWA.q_and = $('#advanced_options_asf .q_and').val();
	HRWA.q_phrase = $('#advanced_options_asf .q_phrase').val();
	HRWA.q_or = $('#advanced_options_asf .q_or').val();
	HRWA.q_exclude = $('#advanced_options_asf .q_exclude').val();
	//generate new q based on q_and, q_phrase, q_or, q_exclude
	HRWA.q = multi_q_to_single_q(HRWA.q_and, HRWA.q_phrase, HRWA.q_or, HRWA.q_exclude);

	sync_to_simple_form = true;
	sync_to_advanced_fsf_form = true;
  }

  //Assign new values to other forms as needed

  if(sync_to_simple_form)
  {
	$('#simple_options #q').val(HRWA.q);
  }

  if(sync_to_advanced_fsf_form)
  {
	$('#advanced_options_fsf .q_and').val(HRWA.q_and);
	$('#advanced_options_fsf .q_phrase').val(HRWA.q_phrase);
	$('#advanced_options_fsf .q_or').val(HRWA.q_or);
	$('#advanced_options_fsf .q_exclude').val(HRWA.q_exclude);
  }

  if(sync_to_advanced_asf_form)
  {
	$('#advanced_options_asf .q_and').val(HRWA.q_and);
	$('#advanced_options_asf .q_phrase').val(HRWA.q_phrase);
	$('#advanced_options_asf .q_or').val(HRWA.q_or);
	$('#advanced_options_asf .q_exclude').val(HRWA.q_exclude);
  }
}

//Add key event stuff

$('#simple_options #q').bind('keyup', function(){
  sync_all_forms('simple');
});

$('#advanced_options_fsf .q_and, ' +
  '#advanced_options_fsf .q_phrase, ' +
  '#advanced_options_fsf .q_or, ' +
  '#advanced_options_fsf .q_exclude').bind('keyup', function(){
  sync_all_forms('advanced_fsf');
});

$('#advanced_options_asf .q_and, ' +
  '#advanced_options_asf .q_phrase, ' +
  '#advanced_options_asf .q_or, ' +
  '#advanced_options_asf .q_exclude').bind('keyup', function(){
  sync_all_forms('advanced_asf');
});

function multi_q_to_single_q(q_and, q_phrase, q_or, q_exclude)
{
  var new_q_and_string = '';
  var new_q_phrase_string = '';
  var new_q_or_string = '';
  var new_q_exclude_string = '';

  //Remove extra whitespace as needed, split on spaces for non-q_phrase fields

  if(q_and.length > 0)
  {
	var q_and_arr = $.trim(q_and).split(' ');
	new_q_and_string = '+' + q_and_arr.join(' +');
	new_q_and_string = new_q_and_string + ' '; //extra space after for formatting
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

  return new_q_and_string + new_q_phrase_string + new_q_or_string + new_q_exclude_string;
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
  //If q is empty, just return four empty values
  if(q == "")
  {
	return ['', '', '', ''];
  }

  var q_and_arr = new Array();
  var q_phrase_arr = new Array();
  var q_or_value = new Array();
  var q_exclude_arr = new Array();

  //We'll be parsing from left to right, but we can't assume that combined q
  //presents and, phrase, or and exclude values in any particular order.

  //It would probably be easiest if we remove quoted q phrase values first

  //Because JS doesn't support regex lookbehinds, I need to find groups
  //of two chars, and then I'll only look at the index located at the two-char index + 1
  var quote_1_position = -1;
  var quote_2_position = -1;

  //First, we look for the special case of a quote appearing at the beginning of q
  //Otherwise we'll be looking for a quotation mark that doesn't come after a backslash
  if(q.charAt(0) == '"')
  {
	quote_1_position = 0;
  }
  else
  {
	quote_1_position = q.regexIndexOf(/[^\\]"/) + 1;
	if(quote_1_position == 0) { quote_1_position = -1; } //correction step because regexIndexOf might return -1
  }
  quote_2_position = q.regexIndexOf(/[^\\]"/, quote_1_position) + 1;
  if(quote_2_position == 0) { quote_2_position = -1; } //correction step because regexIndexOf might return -1

  while(quote_1_position != -1 && quote_2_position != -1)
  {
	//clip this quoted text instance from q (ignoring the quotation marks)
	q_phrase_arr.push(q.substring(quote_1_position+1, quote_2_position));

	//remove this quoted text instance from q (also removing the quotation marks)
	var q_portion_before_first_quotion_mark = q.substring(0, quote_1_position);
	var q_portion_after_second_quotation_mark = (quote_2_position == q.length) ? '' : (q.substring(quote_2_position+1));

	q = $.trim(q_portion_before_first_quotion_mark) + ' ' +  $.trim(q_portion_after_second_quotation_mark); //trim trailing whitespace

	if(q.charAt(0) == '"')
	{
	  quote_1_position = 0;
	}
	else
	{
	  quote_1_position = q.regexIndexOf(/[^\\]"/) + 1;
	}
	if(quote_1_position == 0) { quote_1_position = -1; } //correction step because regexIndexOf might return -1
	quote_2_position = q.regexIndexOf(/[^\\]"/, quote_1_position) + 1;
	if(quote_2_position == 0) { quote_2_position = -1; } //correction step because regexIndexOf might return -1
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

  var parsed_q_phrase = (q_phrase_arr.length == 0) ? '' : q_phrase_arr[0];

  //Now that we've removed the q_phrase items from q, the rest of the parsing should be easier

  //Let's remove any word in q that is preceeded by ' -' (space followed by a minus sign)
  //Note: We can't just look for minus signs alone, since they can also act as hyphens

  /* Commented out for now

  var minus_position = -1;
  var subsequent_space_position = -1;

  //First, we look for the special case of a minus sign appearing at the beginning of q
  //Otherwise we'll be looking for a minus sign that comes after a space
  if(q.charAt(0) == '-')
  {
	minus_position = 0;
  }
  else
  {
	minus_position = q.regexIndexOf(/ -/) + 1;//minus at the beginning of a word
	if(minus_position == 0) { minus_position = -1; } //correction step because regexIndexOf might return -1
  }
  subsequent_space_position = q.indexOf(' ', minus_position);//space at the end of a word
  if(subsequent_space_position)
  while(minus_position != -1 && subsequent_space_position != -1)
  {
	//clip this quoted text instance from q (ignoring the quotation marks)
	q_phrase_arr.push(q.substring(minus_position+1, subsequent_space_position));

	//remove this quoted text instance from q (also removing the quotation marks)
	var q_portion_before_minus = q.substring(0, minus_position);
	var q_portion_after_space = (subsequent_space_position == q.length) ? '' : (q.substring(quote_2_position+1));

	q = $.trim(q_portion_before_first_quotion_mark) + ' ' +  $.trim(q_portion_after_second_quotation_mark); //trim trailing whitespace

	if(q.charAt(0) == '-')
	{
	  minus_position = 0;
	}
	else
	{
	  minus_position = q.regexIndexOf(/ -/) + 1;//minus at the beginning of a word
	  if(minus_position == 0) { minus_position = -1; } //correction step because regexIndexOf might return -1
	}
	subsequent_space_position = q.indexOf(' ', minus_position);//space at the end of a word
  }
  */

  var parsed_q_exclude = '';


  var parsed_q_and = '';

  //And finally, if q_phrase_arr has more than one element, place the > index 0
  //elements in parsed_q_and.
  if(q_phrase_arr.length > 1)
  {
	for(var i = 1; i < q_phrase_arr.length; i++)
	{
	  parsed_q_and += ' "' + q_phrase_arr[i] + '"';
	}
  }

  //Whatever's left in the string can be place in q_or
  var parsed_q_or = q; //this is whatever remains in q after everything else has been removed

  return new Array(parsed_q_and, parsed_q_phrase, parsed_q_or, parsed_q_exclude);
}

/**
 *	Extracts regex match occurrences from the given string,
 *	returning a two-element array:
 *	arr[0] == an array of all matches
 *	arr[1] == the supplied string with all regex matches removed
 */
function extract_matches_from_string(regex, string)
{
  return null;
}

}); // ready
