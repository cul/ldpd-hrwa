# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
#
# Methods added to this helper will be available to all templates in the hosting application
#
module Hrwa::BlacklightHelperBehavior

  def application_name
    return Rails.application.config.application_name if Rails.application.config.respond_to? :application_name

    return 'The Columbia University Human Rights Web Archive'
  end

  # ! Override !
  # We want the field separator to be a semicolon instead of the deafult comma
  def field_value_separator
    '; '
  end

  def render_document_heading
    content_tag(:h3, document_heading)
  end

  # ! Needed to override this to add link_to options
  #
  # link_back_to_catalog(:label=>'Back to Search')
  # Create a link back to the index screen, keeping the user's facet, query and paging choices intact by using session.
  # This method should NEVER be used for archive records, only find_site records
  def link_back_to_catalog(opts={:label=>'Back to Search', :link_to_opts => {}})
    query_params = session[:search] ? session[:search].dup : {}
    query_params.delete :counter
    query_params.delete :total
    # HRWA Note: We're always adding find_site (below) as a query string
    # search_type value because archive records do not have item level view
    # pages and it only makes sense to use this method in a find_site context
    query_params[:search_type] = 'find_site'
    link_url = catalog_index_path + "?" + query_params.to_query
    link_to opts[:label], link_url, opts[:link_to_opts]
  end

  def link_to_previous_document(previous_document)
    return if previous_document == nil
    link_to '<i class="icon-arrow-left"></i>'.html_safe, previous_document, :rel => 'tooltip', :title => 'Previous Item', :class => "previous btn btn-mini", :'data-counter' => session[:search][:counter].to_i - 1
  end

  def link_to_next_document(next_document)
    return if next_document == nil
    link_to '<i class="icon-arrow-right"></i>'.html_safe, next_document, :rel => 'tooltip', :title => 'Next Item', :class => "next btn btn-mini", :'data-counter' => session[:search][:counter].to_i + 1
  end

  # link_to_document(doc, :label=>'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a HashWithIndifferentAccess object. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => false})
   label ||= blacklight_config.index.show_link.to_sym
   label = render_document_index_label doc, opts
   link_to label, doc, { :'data-counter' => opts[:counter], :'data-results_view' => opts[:results_view], :'data-folder_view' => opts[:folder_view]}.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
  end

  # Hrwa note: We don't ever want to show bookmarks, even for logged-in users.  Just folders.
  #
  # Save function area for item detail 'show' view, normally
  # renders next to title. By default includes 'Folder' and 'Bookmarks'
  def render_show_doc_actions(document=@document, options={})
    content = []
    content << render(:partial => 'catalog/folder_control', :locals => {:document=> document}.merge(options))

    content_tag("div", content.join("\n").html_safe, :class=>"documentFunctions")
  end

  # Hrwa note: We don't ever want to show bookmarks, even for logged-in users.  Just folders.
  #
  # Save function area for search results 'index' view, normally
  # renders next to title. Includes just 'Folder' by default.
  def render_index_doc_actions(document, options={})
    content = []
    content << render(:partial => 'catalog/folder_control', :locals => {:document=> document}.merge(options))

    content_tag("div", content.join("\n").html_safe, :class=>"documentFunctions")
  end

end
