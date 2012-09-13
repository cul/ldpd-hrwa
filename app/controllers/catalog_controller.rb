# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Blacklight::Catalog

  before_filter :_check_for_debug_mode

  # get search results from the solr index
  def index
    # TODO: Remove hard-coded 'find_site' search_type below and use the no-argument version of _configure_by_search_type instead
    _configure_by_search_type('find_site')
    _do_search
  end

  def advanced
    _configure_by_search_type
    _do_advanced_search_preprocessing
    _do_search
  end

  # display hrwa_home page, and grab 12 random results from Solr
  def hrwa_home

    _configure_by_search_type(:find_site)

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


  def _do_search
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

  def _do_advanced_search_preprocessing
    @filters = params[:f] || []
  end

  # sets @debug_mode to true if params[:debug_mode] == true
  def _check_for_debug_mode
    @debug_mode = params[:debug_mode] == "true"
    @debug_printout = ''
  end

  def _configure_by_search_type(search_type = params[:search_type])

    if (search_type.nil?)
      # We don't ever want this code to run
      raise 'Search type should not be nil!'
    else
      @search_type = search_type.to_sym
    end

    # Backend method of reselecting search_type based on hrwa_core if hrwa_core is the no-stemming core
    if ( params[ :hrwa_core ] == 'asf-hrwa-278' )
      @search_type = :archive_ns
    end

    @configurator = HRWA::Configurator.new( @search_type )

    # See https://issues.cul.columbia.edu/browse/HRWA-324
    @configurator.reset_configuration( self.blacklight_config )

    # CatalogController.configure_blacklight yields a Blacklight::Configuration object
    # that expects a block/proc which sets its attributes accordingly
    CatalogController.configure_blacklight( &@configurator.config_proc )

    if(@search_type == :archive_ns || !params[:hrwa_host] || params[:hrwa_host].blank?)
        @solr_url = @configurator.solr_url
    else
        #Dev override
        @solr_url = get_solr_host_from_url(@configurator.name, params)
    end

    Blacklight.solr = RSolr::Ext.connect( :url => @solr_url)
  end


end
