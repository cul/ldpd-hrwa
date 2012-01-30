# -*- encoding : utf-8 -*-
require 'blacklight/catalog'
require 'configurator'

class CatalogController < ApplicationController  
  before_filter :_configure_by_search_type

  include Blacklight::Catalog

  private

  def _configure_by_search_type
    # Type instance var for later branching in view code
    @search_type = :archive

    @configurator = Configurator.new( @search_type )
    
    # CatalogController.configure_blacklight yields a Blacklight::Configuration object
    # that expects a block/proc which sets its attributes accordingly
    CatalogController.configure_blacklight( &@configurator.config_proc )
  end

end 
