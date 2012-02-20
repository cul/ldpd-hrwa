require 'blacklight/catalog'
require 'configurator'
require 'pp'

class CatalogController < ApplicationController
  before_filter :_configure_by_search_type, :only => [ :index ]

  include Blacklight::Catalog
  include AdvancedSearch
  include Debug

  #display the site detail for an fsf record, using bib_key as a unique identifier
  def site_detail
    @bib_key = params[:bib_key]
    #get_solr_response_for_doc_id
  end

  # get search results from the solr index
  def index

    extra_head_content << view_context.auto_discovery_link_tag(:rss, url_for(params.merge(:format => 'rss')), :title => "RSS for results")
    extra_head_content << view_context.auto_discovery_link_tag(:atom, url_for(params.merge(:format => 'atom')), :title => "Atom for results")

    if params[ :search_mode ] == "advanced"
      # Advanced search form doesn't have a "q" textbox.  If there's anything in
      # user param q it shouldn't be there
      params[ :q ] = nil

      # Blacklight expects a 'q' SOLR param so we must build one from the q_* text params
      # Blacklight::SolrHelper#get_search_results takes optional extra_controller_params
      # hash that is merged into/overrides user_params
      extra_controller_params = {}
      process_q_type_params extra_controller_params, params

      # Now use interpreted advanced search as user param q for echo purposes
      params[ :q ] = extra_controller_params[ :q ]
    end

    #Don't perform a search if the query params aren't set

    if _perfoming_a_search?

      (@response, @result_list) = get_search_results( params,
                                                      extra_controller_params ||= {} )

      @filters = params[:f] || []

      # Select appropriate partials
      @result_partial = @configurator.result_partial
      @result_type    = @configurator.result_type

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

      # TODO: remove me
      # if(@search_type == :archive)
        # render :text => %Q{CatalogController currently broken.  This is a temporary
                        # manual render to keep Rails from crashing.\n
                        # <br/>"Search Tips" - this string is here to enable Capybara
                        # request test to pass <br/> #{@debug}} and return
      # end

    end

    respond_to do |format|
      format.html { save_current_search_params }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
    end
  end

  private

  def _configure_by_search_type
    @debug = ''.html_safe

    Rails.logger.debug(params.pretty_inspect)

    @search_type = params[:search_type].to_sym

    @configurator = Configurator.new( @search_type )

    # CatalogController.configure_blacklight yields a Blacklight::Configuration object
    # that expects a block/proc which sets its attributes accordingly
    CatalogController.configure_blacklight( &@configurator.config_proc )

    Blacklight.solr = RSolr::Ext.connect( :url => @configurator.solr_url )
  end

  # TODO: Fix method redundancy:
  # There is anothr similar method that's being used as a helper
  # method (has_search_parameters?), but the method below is
  # needed by the catalog controller index action

  # Returns true if the user is performing a search,
  # false if
  def _perfoming_a_search?
    if params[:search_mode] == 'advanced'
      return( !params[:q_and].blank?     or
              !params[:q_exclude].blank? or
              !params[:q_phrase].blank?  or
              !params[:q_not].blank?     or
              !params[:f].blank?         or
              !params[:search_field].blank? )
    else
      return !params[:q].blank?
    end
  end

end
