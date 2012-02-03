# -*- encoding : utf-8 -*-
require 'blacklight/catalog'
require 'configurator'
require 'hrwa/debug'
require 'pp'

class CatalogController < ApplicationController  
  before_filter :_configure_by_search_type

  include Blacklight::Catalog
  include Hrwa::AdvancedSearch
  include Hrwa::Debug
      
  private

  def _configure_by_search_type
    @debug = params_list.html_safe
  
    # Type instance var for later branching in view code
    @search_type = :archive

    @configurator = Configurator.new( @search_type )
    
    if params[ :search_mode ] == "advanced"
      self.solr_search_params_logic << :process_q_and
      self.solr_search_params_logic << :process_q_or
      self.solr_search_params_logic << :process_q_phrase
      self.solr_search_params_logic << :process_q_exclude  
    end
   
    # CatalogController.configure_blacklight yields a Blacklight::Configuration object
    # that expects a block/proc which sets its attributes accordingly
    CatalogController.configure_blacklight( &@configurator.config_proc )
    
  end

end 
