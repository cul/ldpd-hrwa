# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Blacklight::Catalog

  before_filter :_check_for_debug_mode, :_configure_by_controller_action

  def _configure_by_controller_action

    case params[:action].to_s
    when 'index'
      _configure_by_search_type
    when 'advanced'
      _configure_by_search_type
    when 'show'
      _configure_by_search_type('site_detail')
    when 'update'
      _configure_by_search_type('site_detail')
      puts 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'
    when 'hrwa_home'
      _configure_by_search_type('find_site')
      puts 'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC'
    else
      # We don't ever want this code to run
      raise 'Search type should not be nil! _configure_by_search_type is not being called for this catalog controller action.'
      puts 'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD'
    end

  end

  # get search results from the solr index
  def index
    _do_search
  end

  def advanced
    _do_advanced_search_params_preprocessing
    _do_search
  end

  # display hrwa_home page, and grab 12 random results from Solr
  def hrwa_home

    number_of_items_to_show = 12

    # add a new solr facet query ('fq') parameter that performs a radom subject facet search
    @random_subjects_to_choose_from =  [ 'Civil rights',
                                      'Democracy',
                                      'Ombudspersons',
                                      'Civil society',
                                      'Transitional justice',
                                      'Indigenous peoples',
                                      'Torture',
                                      'Truth commissions']

    # If a subject has been specified in the query string, use it.  Otherwise choose something random.
    if(params[:subject] && @random_subjects_to_choose_from.include?(params[:subject]))
       @featured_home_page_subject = params[:subject]
    else
      @featured_home_page_subject = (@random_subjects_to_choose_from.shuffle)[0] # Get random item without reordering the hash
    end

    custom_solr_search_params =  {
                                    :rows => number_of_items_to_show,
                                    :fq => '{!raw f=subject__facet}' + @featured_home_page_subject
                                  }

    (@response, @result_list) = get_search_results(params, custom_solr_search_params)

    custom_blacklight_search_params = {
                                        :per_page => number_of_items_to_show,
                                        :f=>{"subject__facet"=>[@featured_home_page_subject]},
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
      (@response, @result_list) = get_search_results
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

    # TODO: Take this out once we've resolved HRWA-377 (https://issues.cul.columbia.edu/browse/HRWA-377)
    # Check for navigation to a nonexistent/invalid result page
    # if search_type == asf, page > 1 and result_count == 0, THAT'S BAD!
    if(@result_list.empty? && params[:search_type] == 'archive' && params[:page] && params[:page].to_i > 1)
      @error_type = :invalid_result_page
      @error_message = 'Sorry, but there are no results available on this search result page.'
      Rails.logger.info('-------------------------------------------------------------------------------------')
      Rails.logger.info('HRWA-377 Error: (no results on page). params == ' + params.to_s)
      Rails.logger.info('-------------------------------------------------------------------------------------')
      render :error and return
    end

    # Configurator might need to manipulate the @response and @result_list
    # This is absolutely the case for an archive search
    if @configurator.post_blacklight_processing_required?
      @response, @result_list = @configurator.post_blacklight_processing( @response,
                                                                          @result_list )
    end

    # Select appropriate partials
    @result_partial = @configurator.result_partial
    @result_type    = @configurator.result_type

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

  def _do_advanced_search_params_preprocessing
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
