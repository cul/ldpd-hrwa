# -*- encoding : utf-8 -*-
require 'hrwa/archive_search_configurator'
require 'hrwa/find_site_search_configurator'

class HRWA::Configurator
  unloadable

  include HRWA::AdvancedSearch

  def initialize( search_request_type )
    case search_request_type
      when :archive
        @configurator = HRWA::ArchiveSearchConfigurator.new
      when :find_site
        @configurator = HRWA::FindSiteSearchConfigurator.new
    end
  end

  def config_proc
    return @configurator.config_proc
  end

  # Did Blacklight give us everything we need in SOLR response and
  # results list objects?
  def post_blacklight_processing_required?
    return @configurator.post_blacklight_processing_required?
  end

  # Do more with the SOLR response and results list that Blacklight
  # gives us.
  def post_blacklight_processing( solr_response, results_list )
    return @configurator.post_blacklight_processing( solr_response, results_list )
  end

  def process_search_request( extra_controller_params, user_params = params )
    @configurator.process_search_request( extra_controller_params, user_params )
  end

  # See https://issues.cul.columbia.edu/browse/HRWA-324
  def reset_configuration( config )
    if not config.methods.select { | method_name |
         method_name =~ /^facet_fields|^index_fields|^search_fields|^show_fields|^sort_fields/ }.empty?
      config.facet_fields  = {}
      config.index_fields  = {}
      config.search_fields = {}   
      config.show_fields   = {}
      config.sort_fields   = {}
    end
  end
  
  def result_partial
    return @configurator.result_partial
  end

  def result_type
    return @configurator.result_type
  end

  def solr_url
    return @configurator.solr_url
  end

  def prioritized_highlight_field_list
    return @configurator.prioritized_highlight_field_list
  end

end
