# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Blacklight::Catalog

  before_filter :_check_for_debug_mode

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      :qt => 'search',
      :defType          => "edismax",
      :facet            => true,
      :'facet.mincount' => 1,
      :'q.alt'          => "*:*",
      :qf               => [
                            'item_title^1',
                            'item_annotation_original_recto^1',
                            'item_annotation_original_verso^1',
                            'group_title^1',
                            'subject_geographic^1',
                            'topic_subject^1',
                            'associated_name^1',
                            'subject_name^1',
                            'item_number^1',
                            'format^1',
                            ],
      :rows             => 30,

    }

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  :qt => 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # :fl => '*',
    #  # :rows => 1
    #  # :q => '{!raw f=id v=$id}'
    #}

    # solr field configuration for search results/index views
    config.index.show_link = 'item_title'
    config.index.record_display_type = 'format'

    # solr field configuration for document/show views
    config.show.html_title = 'item_title'
    config.show.heading = 'item_title'
    config.show.display_type = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    config.add_facet_field 'subject_geographic__facet', :label => 'Place', :limit => 10
    config.add_facet_field 'topic_subject__facet', :label => 'Topic', :limit => 10
    config.add_facet_field 'subject_name__facet', :label => 'Name', :limit => 10
    config.add_facet_field 'associated_name__facet', :label => 'Creator', :limit => 10
    config.add_facet_field 'state_or_province__facet', :label => 'State & Province', :limit => 10
    config.add_facet_field 'format', :label => 'Format', :limit => 10

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    #use this instead if you don't want to query facets marked :show=>false
    #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'item_title', :label => 'Title:'
    config.add_index_field 'format', :label => 'Format:'
    config.add_index_field 'box_number', :label => 'Box Number:'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display

    # Hrwa Note: The show fields below are commented out because
    # we have specific layout needs that make it inconvenient to automatically
    # render this data using Blacklight default functionality.

    #config.add_show_field 'item_title', :label => 'Title'
    #config.add_show_field 'display_date_free_text', :label => 'Date'
    #config.add_show_field 'date_source_note', :label => 'Date Note'
    #config.add_show_field 'item_size', :label => 'Measurements'
    #config.add_show_field 'item_number', :label => 'Item Number'
    #config.add_show_field 'format', :label => 'Format'
    #config.add_show_field 'item_annotation_original_recto', :label => 'Recto Annotation'
    #config.add_show_field 'item_annotation_original_verso', :label => 'Verso Annotation'
    #config.add_show_field 'public_note', :label => 'Note'
    #config.add_show_field 'subject_name', :label => 'People & Organizations' #Multi
    #config.add_show_field 'subject_geographic', :label => 'Place' #Multi
    #config.add_show_field 'state_or_province', :label => 'State & Province'
    #config.add_show_field 'topic_subject', :label => 'Topics' #Multi
    #config.add_show_field 'associated_name', :label => 'Creator' #Multi
    #config.add_show_field 'collection', :label => 'Collecton'
    #config.add_show_field 'folder_title', :label => 'Folder Title'
    #config.add_show_field 'folder_number', :label => 'Folder Number'
    #config.add_show_field 'group_title', :label => 'Group Title'
    #config.add_show_field 'box_number', :label => 'Box Number'
    #config.add_show_field 'repository', :label => 'Repository'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', :label => 'All Fields'

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc', :label => 'relevance'
    config.add_sort_field 'item_title__sort asc', :label => 'a-z'
    config.add_sort_field 'item_title__sort desc', :label => 'z-a'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 0
  end

  # get search results from the solr index
  def index

    extra_head_content << view_context.auto_discovery_link_tag(:rss, url_for(params.merge(:format => 'rss')), :title => "RSS for results")
    extra_head_content << view_context.auto_discovery_link_tag(:atom, url_for(params.merge(:format => 'atom')), :title => "Atom for results")

    # Be ready to capture Solr errors
    begin
      (@response, @document_list) = get_search_results
    rescue => ex
      @error = ex.to_s
      Rails.logger.error( @error )

      # Check to see if the query couldn't be understood by Solr
      if ! ex.to_s.match( /HTTP Status 400/).nil?
        # Get query text if there is any
        user_q_text    = ex.request[ :params ][ :q ]
        user_query     = user_q_text.blank? ? 'your query' : %Q{your query "#{ user_q_text }"}
        @alert_type    = 'alert-info'
        @error_message = "Sorry, #{user_query} is not valid. Please try a different search.".html_safe
      else
        @alert_type    = 'alert-error'
        @error_message = "Sorry, an internal system error has occurred.".html_safe
      end

      render :error and return
    end
    @filters = params[:f] || []

    if(@debug_mode)
      @debug_printout << "session[:search]:\n"
      @debug_printout << session[:search].pretty_inspect
      @debug_printout << "\n\n"
      @debug_printout << "Solr Response:\n"
      @debug_printout << @response.pretty_inspect
    end

    respond_to do |format|
      format.html { save_current_search_params }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
    end
  end

  # sets @debug_mode to true if params[:debug_mode] == true
  def _check_for_debug_mode
    @debug_mode = params[:debug_mode] == "true"
    @debug_printout = ''
  end

  # display hrwa_home page, and grab 12 random results from Solr
  def hrwa_home

    number_of_items_to_show = 12

    # add a new solr facet query ('fq') parameter that performs a radom topic facet search
    @random_topics_to_choose_from =  [ 'School buildings',
                                      'Indian women',
                                      'Indian men',
                                      'Indian students',
                                      'Automobiles',
                                      'Winter',
                                      'Missionaries',
                                      'Tipis',
                                      'Lakes',
                                      'Sports',
                                      'Horses' ]

    # If a topic has been specified in the query string, use it.  Otherwise choose something random.
    if(params[:topic] && @random_topics_to_choose_from.include?(params[:topic]))
       @featured_home_page_topic = params[:topic]
    else
      @featured_home_page_topic = (@random_topics_to_choose_from.shuffle)[0] # Get random item without reordering the hash
    end

    custom_solr_search_params =  {
                                    :rows => number_of_items_to_show,
                                    :fq => '{!raw f=topic_subject__facet}' + @featured_home_page_topic
                                  }

    (@response, @document_list) = get_search_results(params, custom_solr_search_params)

    custom_blacklight_search_params = {
                                        :per_page => number_of_items_to_show,
                                        :f=>{"topic_subject__facet"=>[@featured_home_page_topic]},
                                        :total => @response.total
                                      }

    session[:search] = params.merge(custom_blacklight_search_params)

    if(@debug_mode)
      @debug_printout << "session[:search]:\n"
      @debug_printout << session[:search].pretty_inspect
      @debug_printout << "\n\n"
      @debug_printout << "Solr Response:\n"
      @debug_printout << @response.pretty_inspect
    end

  end

end
