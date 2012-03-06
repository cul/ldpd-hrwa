jQuery(function($) {
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

  $('#advanced_options').hide(0).removeClass('hidden');
  $('#advo').css('visibility','visible');
  $('.advtoggle').bind('click', function (e) {
	if($('#advanced_options').parent().attr('id') == 'advanced_options_outside_of_form')
	{
	  $('#advanced_options').appendTo('#advanced_options_inside_of_form').show();
	  $(this).text('-');
	}
	else
	{
	  $('#advanced_options').hide().appendTo('#advanced_options_outside_of_form');
	  $(this).text('+');
	}

	$(this).blur();
	return false;
  });

  $('#advsubmit').live('click', function(e) {
    if ($('#q_and').val() != '' || $('#q_phrase').val() != '' || $('#q_or').val() != '' || $('#q_exclude').val() != '') {
        if ($('#q_and').val() != '') { var q_and = '+'+$('#q_and').val(); } else { var q_and = ''; }
        if ($('#q_phrase').val() != '') { var q_phrase = ' "'+$('#q_phrase').val()+'" '; } else { var q_phrase = ' '; }
        if ($('#q_or').val() != '') { var q_or = $('#q_or').val()+' '; } else { var q_or = ' '; }
        if ($('#q_exclude').val() != '') { var q_exclude = '-'+$('#q_exclude').val(); } else { var q_exclude = ''; }
        var newaq = q_and.replace(/ /g,' +')+q_phrase+q_or+q_exclude.replace(/ /g,' -');
        //$('#q').val(newaq.replace(/"/g, "&quot;").replace(/'/g, "&#039;"));
        $('#q, #q_t').val(newaq);
    }
    $('#searchform').submit();
  });
  $('#advreset').live('click', function(e) {
	$('#advanced_options input[type=text]').val('');
  });

  $('.submitss').parent().css('visibility','visible');
  $('.submitss').live('click', function (e) {
	var cform = $(this).closest('form');
	if ($('#q_t').val() != '' || $('#q').val()) {
		cform.submit();
	}
	cform.submit();
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
 $('#advanced_options select[multiple=multiple]').multiselect({
   selectedText: "# of # selected"
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

//Only show toggle buttons if there's at least one search result
if($('article.post').length > 0)
{
  $('.results_control').show();
  $('.toggle_all_btn').attr('data-status', 'less-mode').live('click', function() {
    if($(this).attr('data-status') == 'less-mode')
    {
      $(this).attr('data-original-title', 'Show less detailed results');
      toggle_item_detail($('article.post .toggle_section'), 'show');
      $(this).attr('data-status', 'more-mode');
      $(this).text('Show less detail -');
    }
    else
    {
      $(this).attr('data-original-title', 'Show more detailed results');
      toggle_item_detail($('article.post .toggle_section'), 'hide');
      $(this).attr('data-status', 'less-mode');
      $(this).text('Show more detail +');
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

}); // ready
