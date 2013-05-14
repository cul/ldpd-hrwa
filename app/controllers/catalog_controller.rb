# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Blacklight::Catalog
  include Hrwa::SolrHelper

  before_filter :_check_for_debug_mode, :_configure_by_controller_action, :_select_appropriate_partial

  def _configure_by_controller_action

    case params[:action].to_s
      when 'index'
        if ! params[:search_type]
          _configure_by_search_type('find_site')
        else
          _configure_by_search_type
        end
      when 'show'
        _configure_by_search_type('site_detail')
      when 'update'
        _configure_by_search_type('site_detail')
      when 'facet'
        _configure_by_search_type
      else
      # In general, we use the find_site configuration, but there are certain exceptions (above)
        _configure_by_search_type('find_site')
      end
    end

  # get search results from the solr index
  def index
    _do_search
  end

  def advanced
    if params[:submit]
      _do_advanced_query_processing_and_redirect
    end
  end

  def _do_advanced_query_processing_and_redirect

    # Also ignore params[:catalog]
    params.delete(:catalog)

    # Also ignore params[:submit]
    params.delete(:submit)

    # Ignore all empty params items
    params.delete_if{|key, value|
      value.blank? || (value.is_a?(Array) && (value.length == 0 || (value.length == 1 && value[0].blank?)))
    }

    # Combine q_and, q_phrase, q_or, q_exclude into q

    combined_q = ''

    q_and = params[:q_and]                                                      unless params[:q_and].blank?
    q_and = q_and.split( /\s+/ ).map { |term| "+#{term}" }.join( ' ' )          unless params[:q_and].blank?
    q_phrase = '"' + params[:q_phrase] + '"'                                    unless params[:q_phrase].blank?
    q_or = params[:q_or]                                                        unless params[:q_or].blank?
    q_or = q_or.split( /\s+/ ).map { |term| "#{term}" }.join( ' ' )             unless params[:q_or].blank?
    q_exclude = params[:q_exclude]                                              unless params[:q_exclude].blank?
    q_exclude = q_exclude.split( /\s+/ ).map { |term| "-#{term}" }.join( ' ' )  unless params[:q_exclude].blank?

    combined_q << q_and     + ' ' unless q_and.blank?
    combined_q << q_phrase  + ' ' unless q_phrase.blank?
    combined_q << q_or      + ' ' unless q_or.blank?
    combined_q << q_exclude + ' ' unless q_exclude.blank?

    unless combined_q.blank?
      combined_q = combined_q[0,combined_q.length-1]
    end

    params[:q] = combined_q

    # and remove the advanced text fields from params
    params.delete(:q_and)
    params.delete(:q_phrase)
    params.delete(:q_or)
    params.delete(:q_exclude)

    # Ignore all empty params[:f] items
    params[:f].delete_if{|key, value|
      value.blank? || (value.is_a?(Array) && (value.length == 0 || (value.length == 1 && value[0].blank?)))
    }

    redirect_to params.merge({:action => 'index'})
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

    _append_default_debug_printout_items()

  end


  def _do_search
    extra_head_content << view_context.auto_discovery_link_tag(:rss, url_for(params.merge(:format => 'rss')), :title => "RSS for results")
    extra_head_content << view_context.auto_discovery_link_tag(:atom, url_for(params.merge(:format => 'atom')), :title => "Atom for results")

    #Remove extra :search_type_mobile_button param if it exists
    params.delete(:search_type_mobile_button)

    #Cache expansion term data from csv file
    cache_search_expansion_csv_file_data #important!

    # Check for search expansion terms during archive searches IF we are not already performing a search expansion (i.e. params[:search_expansion] is set)
    if params[:search_type] == 'archive'
      @expanded_search_terms_found, @expanded_search_terms = find_expanded_search_terms_for_query(params[:q])
    end

    if params[:search_expansion] == 'true'
      if @expanded_search_terms_found

        @search_expansion_is_on = true
        #Then we want to apply the expanded terms to the current query.  Let's reconstruct the query:
        @original_query = params[:q]
        @expanded_query = get_expanded_query_from_expanded_search_terms_array(@expanded_search_terms)

      else
        #If search_expansion is ON and we didn't find any search expansion terms, redirect to URL that doesn't contain the search_expansion param
        params.delete(:search_expansion)
        redirect_to params
      end
    end

    if @search_expansion_is_on
      params[:q] = @expanded_query
    end

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
        @error_type    = :user
        @alert_type    = 'alert-info'
        @error_message = "Sorry, #{user_query} is not valid. Please try another search with different search terms.".html_safe
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

    _append_default_debug_printout_items()

    if @search_expansion_is_on
      params[:q] = @original_query
    end

    respond_to do |format|
      format.html { save_current_search_params }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
    end
  end

  def _append_default_debug_printout_items
    if(@debug_mode)
      @debug_printout << "----------\n\n"
      @debug_printout << "solr core:\n\n"
      @debug_printout << @configurator.solr_url + "\n\n"
      @debug_printout << "----------\n\n"
      @debug_printout << "session[:search]:\n\n"
      @debug_printout << session[:search].pretty_inspect + "\n"
      @debug_printout << "----------\n\n"
      @debug_printout << "Solr Response:\n\n"
      @debug_printout << @response.pretty_inspect + "\n"
      @debug_printout << "----------\n\n"
    end
  end

  # sets @debug_mode to true if params[:debug_mode] == true
  def _check_for_debug_mode
    @debug_mode = (params[:debug_mode] == "true")
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

    @configurator = Hrwa::Configurator.new( @search_type )

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

  def _select_appropriate_partial
    # Select appropriate partial
    @result_partial = @configurator.result_partial
    @result_type    = @configurator.result_type
  end


end
