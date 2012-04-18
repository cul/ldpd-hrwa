require 'blacklight/catalog'
require 'pp'

class CatalogController < ApplicationController

  include Blacklight::Catalog
  include HRWA::AdvancedSearch::Query
  include HRWA::Debug
  include HRWA::SolrHelper
  include HRWA::Catalog::Dev

  before_filter :_merge_f_add_into_f, :only => [:index]

  # displays values and pagination links for a single facet field
  def facet
    _configure_by_search_type
    @configurator.configure_facet_action( self.blacklight_config )
    @pagination = get_facet_pagination(params[:id], params)
  end

  # get search results from the solr index
  def index
    if !params[:search].blank?

      _configure_by_search_type

      begin
        (@response, @result_list) = get_search_results( params, {} )
      rescue => ex
        @error = ex.to_s
        Rails.logger.error( @error )

        # We are categorizing user errors into :user and :system
        if ! ex.to_s.match( /org\.apache\.lucene\.queryParser\.ParseException/).nil?
          # Get query text if there is any
          user_q_text    = ex.request[ :params ][ :q ]
          user_query     = user_q_text.blank? ? 'your query' : %Q{your query "#{ user_q_text }"}
          @error_type    = :user
          @error_message = "Sorry, #{user_query} is not valid.  For query syntax help, see <a href='#'>[placeholder for help link]</a>.".html_safe
        else
          @error_type    = :system
          @error_message = "Sorry, there has been an internal system error.  Please contact <a href='#'>[placeholder for help link]</a>.".html_safe
        end
        # TODO: remove this from production version
        if params.has_key?( :hrwa_debug )
          _set_debug_display
        end

        render :error and return
      end

      # TODO: Take this out once we've resolved HRWA-377 (https://issues.cul.columbia.edu/browse/HRWA-377)
      # Check for navigation to a nonexistent/invalid result page
      # if search_type == asf, page > 1 and result_count == 0, THAT'S BAD!
      if(@result_list.empty? && params[:search_type] == 'archive' && params[:page] && params[:page].to_i > 1)
        @error_type = :invalid_result_page
        @error_message = 'Sorry, but there are no results available on this search result page.'
        render :error and return
      end

      # Configurator might need to manipulate the @response and @result_list
      # This is absolutely the case for an archive search
      if @configurator.post_blacklight_processing_required?
        @response, @result_list = @configurator.post_blacklight_processing( @response,
                                                                            @result_list )
      end

      @filters = params[:f] || []

      # Select appropriate partials
      @result_partial = @configurator.result_partial
      @result_type    = @configurator.result_type
      @solr_url       = @configurator.solr_url

      # TODO: remove this from production version
      if params.has_key?( :hrwa_debug )
        _set_debug_display
      end

      respond_to do |format|
        format.html { save_current_search_params }
        format.rss  { render :layout => false }
        format.atom { render :layout => false }
      end

    end

  end

  # display the site detail for an fsf record, using bib_key as a unique identifier
  # use the bib_key to get a single document from the solr index
  def site_detail
    _configure_by_search_type('site_detail')
    @bib_key = params[:bib_key]
    @response, @document = get_solr_response_for_doc_id(@bib_key)
  end

  private

  def _configure_by_search_type(search_type = params[:search_type])
    @debug = ''.html_safe

    @search_type = search_type.to_sym

    @configurator = HRWA::Configurator.new( @search_type )

    # See https://issues.cul.columbia.edu/browse/HRWA-324
    @configurator.reset_configuration( self.blacklight_config )

    # CatalogController.configure_blacklight yields a Blacklight::Configuration object
    # that expects a block/proc which sets its attributes accordingly
    CatalogController.configure_blacklight( &@configurator.config_proc )

    solr_url = (!params[:hrwa_host] || params[:hrwa_host].blank?) ? @configurator.solr_url : get_solr_host_from_url(@configurator.name, params)

    Blacklight.solr = RSolr::Ext.connect( :url => solr_url)
  end

  def _set_debug_display
    @debug << "<h1>@result_partial = #{ @result_partial }</h1>".html_safe
    @debug << "<h1>@result_type    = #{ @result_type }</h1>".html_safe

    @debug << "<h1>@solr_url    = #{ @solr_url }</h1>".html_safe

    @debug << "<h1>params[]</h1>".html_safe
    @debug << params_list

    @debug << '<h1>solr_search_params_logic</h1>'.html_safe
    @debug << array_pp( self.solr_search_params_logic )

    @debug << "<h1>self.solr_search_params( params )</h1>\n\n".html_safe
    solr_search_parameters = self.solr_search_params( params )
    solr_search_parameters.keys.sort{ | a, b | a.to_s <=> b.to_s }.each do | key |
      @debug << "<strong>#{key}</strong> = ".html_safe << solr_search_parameters[ key ].to_s << "<br/>".html_safe
    end

    if @response
      @debug << '<h1>@response.request_params</h1>'.html_safe
      @debug << "<pre>#{ @response.request_params.pretty_inspect }</pre>".html_safe

      @debug << '<h1>@result_list</h1>'.html_safe
      @debug << "<pre>#{ @result_list.pretty_inspect }".html_safe

      @debug << '<h1>@response</h1>'.html_safe
      @debug << "<pre>#{ @response.pretty_inspect }</pre>".html_safe
    end
  end

  # Merges params[:f_add] options into the current params[:f] hash.
  # Ignores all options that have empty values
  def _merge_f_add_into_f
    if(params[:f_add])

      if( ! params[:f] )
        params[:f] = {}
      end

      #Note: We're not merging the hashes themselves, but rather,
      #the arrays inside each of the hashes.
      params[:f_add].each do |hash_key, arr_value|

				# if f_add contains a key that holds a single-element blank
				# value ( [''] ), then don't do a merge.
				if( ! arr_value[0].blank? )
					if( ! params[:f][hash_key] )
						params[:f][hash_key] = []
					end
					params[:f][hash_key] = params[:f][hash_key] | arr_value # Note: arr1 | arr2 == a single merged array (with duplicates removed)
				end

      end

    end

    # And now that we're done with f_add, we should delete it from params
    # It was only meant to be used right before the catalog_controller index
    # action anyway. It shouldn't be used by any other part of blacklight,
    # or our application.
    params.delete :f_add

  end

  def crawl_calendar
  end

end
