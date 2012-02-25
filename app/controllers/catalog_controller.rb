require 'blacklight/catalog'
require 'pp'

class CatalogController < ApplicationController
  before_filter :_configure_by_search_type, :only => [ :index ]

  include Blacklight::Catalog
  include HRWA::AdvancedSearch
  include HRWA::Debug

  # get search results from the solr index
  def index
    # Params that fall outside of current standarad Blacklight processing
    @extra_controller_params = {}
    
    # Advanced searches require some extra params manipulation
    _advanced_search_processing if params[ :search_mode ] == "advanced"

    @configurator.search_type_specific_processing( @extra_controller_params, params )
    
    begin
      (@response, @result_list) = get_search_results( params,
                                                      @extra_controller_params )
    rescue => ex
      @errors = ex.to_s.html_safe
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

    # TODO: remove this from production version
    if params.has_key?( :hrwa_debug )
      _set_debug_display( extra_controller_params )
    end

    respond_to do |format|
      format.html { save_current_search_params }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
    end
  end


  # display the site detail for an fsf record, using bib_key as a unique identifier
  # use the bib_key to get a single document from the solr index
  def site_detail
    @bib_key = params[:bib_key]
  end


  private
  
  def _advanced_search_processing
    _advanced_search_processing_q_fields( @extra_controller_params, params )
    @configurator.advanced_search_processing( @extra_controller_params, params )
  end
  
  def _advanced_search_processing_q_fields( extra_controller_params, params )
    # Advanced search form doesn't have a "q" textbox.  If there's anything in
    # user param q it shouldn't be there
    params[ :q ] = nil

    # Blacklight expects a 'q' SOLR param so we must build one from the q_* text params
    # Blacklight::SolrHelper#get_search_results takes optional extra_controller_params
    # hash that is merged into/overrides user_params
    process_q_type_params extra_controller_params, params

    # Now use interpreted advanced search as user param q for echo purposes
    params[ :q ] = extra_controller_params[ :q ]
  end
  
  def _set_debug_display( extra_controller_params = {} )       
    @debug << "<h1>@result_partial = #{@result_partial}</h1>".html_safe
    @debug << "<h1>@result_type    = #{@result_type}</h1>".html_safe

    @debug << "<h1>extra_controller_params</h3>".html_safe
    @debug << hash_pp( extra_controller_params )

    @debug << "<h1>params[]</h1>".html_safe
    @debug << params_list

    @debug << '<h1>solr_search_params_logic</h1>'.html_safe
    @debug << array_pp( self.solr_search_params_logic )

    @debug << "<h1>solr_search_params after get_search_results has run</h1>\n\n".html_safe
    self.solr_search_params.each_pair do |key, value|
      @debug << "<strong>#{key}</strong> = #{value} <br/>".html_safe
    end

    @debug << '<h1>@response.request_params</h1>'.html_safe
    @debug << "<pre>#{ @response.request_params.pretty_inspect }</pre>".html_safe

    @debug << '<h1>@result_list</h1>'.html_safe
    @debug << "<pre>#{ @result_list.pretty_inspect }".html_safe

    @debug << '<h1>@response</h1>'.html_safe
    @debug << "<pre>#{ @response.pretty_inspect }</pre>".html_safe
  end

  def _configure_by_search_type
    @debug = ''.html_safe

    Rails.logger.debug(params.pretty_inspect)

    @search_type = params[:search_type].to_sym

    @configurator = HRWA::Configurator.new( @search_type )

    # CatalogController.configure_blacklight yields a Blacklight::Configuration object
    # that expects a block/proc which sets its attributes accordingly
    CatalogController.configure_blacklight( &@configurator.config_proc )

    Blacklight.solr = RSolr::Ext.connect( :url => @configurator.solr_url )
  end

end
