# -*- encoding : utf-8 -*-
require 'hrwa/archive_search_configurator'
require 'hrwa/archive_search_with_stemming_adjuster_configurator'
require 'hrwa/find_site_search_configurator'
require 'hrwa/site_detail_configurator'

class HRWA::Configurator

  include HRWA::AdvancedSearch

  def initialize( search_request_type )

    case search_request_type
      when :archive
        @configurator = HRWA::ArchiveSearchConfigurator.new
      when :archive_ns
        @configurator = HRWA::ArchiveSearchWithStemmingAdjusterConfigurator.new
      when :find_site
        @configurator = HRWA::FindSiteSearchConfigurator.new
      when :site_detail
        @configurator = HRWA::SiteDetailConfigurator.new
    end
  end

  def config_proc
    return @configurator.config_proc
  end

  def configure_facet_action( blacklight_config )
    @configurator.configure_facet_action( blacklight_config )
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

  def process_search_request( solr_parameters, user_params = params )
    @configurator.process_search_request( solr_parameters, user_params )
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

  def default_num_rows
    return @configurator.default_num_rows
  end

  def solr_url
    return @configurator.class.solr_url
  end

  def self.reset_solr_config
    HRWA::ArchiveSearchConfigurator.reset_solr_config
    HRWA::FindSiteSearchConfigurator.reset_solr_config
    HRWA::SiteDetailConfigurator.reset_solr_config
    HRWA::ArchiveSearchWithStemmingAdjusterConfigurator.reset_solr_config
  end

  def self.override_solr_url(new_solr_yaml)
    HRWA::ArchiveSearchConfigurator.override_solr_url(new_solr_yaml)
    HRWA::FindSiteSearchConfigurator.override_solr_url(new_solr_yaml)
    HRWA::SiteDetailConfigurator.override_solr_url(new_solr_yaml)
    HRWA::ArchiveSearchWithStemmingAdjusterConfigurator.override_solr_url(new_solr_yaml)
  end

  def prioritized_highlight_field_list
    return @configurator.prioritized_highlight_field_list
  end

  def name
    return @configurator.name
  end

end
