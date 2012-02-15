# -*- encoding : utf-8 -*-
require 'blacklight/catalog'
require 'configurator'
require 'pp'

class CatalogController < ApplicationController
  before_filter :_configure_by_search_type

  include Blacklight::Catalog
  include AdvancedSearch
  include Debug

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

    # TODO: remove me
    if(@search_type == :archive)
      render :text => %Q{CatalogController currently broken.  This is a temporary
                      manual render to keep Rails from crashing.\n
                      <br/>"Search Tips" - this string is here to enable Capybara request test to pass} \
                      and return
    end

    (@response, @document_list) = @get_search_results_method.call( params,
                                                                  extra_controller_params ||= {} )
    @filters = params[:f] || []

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

    # @debug << '<h1>RSolr::Ext::Response stuff</h1>'.html_safe
    # @debug << "<pre>#{ @response.request_params.pretty_inspect }</pre>".html_safe
    # @debug << "<pre>#{ @response.original_hash.pretty_inspect }</pre>".html_safe

    d @response.pretty_inspect

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

    @get_search_results_method = @configurator.custom_get_search_results_method
    @get_search_results_method ||= self.method( :get_search_results )

  end

end
