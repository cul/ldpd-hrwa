module Hrwa::SolrHelper
  extend ActiveSupport::Concern

  included do
    # Add our own processing to the end of the standard Blacklght SOLR
    # params method chain.  Note that in our deployments we tend to cache
    # controllers so this append to solr_search_params_logic must happen upon
    # include and not inside the controller action.  Otherwise the
    # solr_search_params_logic chaing will grow with each request.

    self.solr_search_params_logic << :process_search_request
  end

  # This has to be defined in controller in order to be added to solr_search_params_logic
  def process_search_request( solr_parameters, user_params )
    @configurator.process_search_request( solr_parameters, user_params )
  end

end
