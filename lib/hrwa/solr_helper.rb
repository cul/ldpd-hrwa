module HRWA::SolrHelper
  extend ActiveSupport::Concern
  
  included do
    # Add our own processing to the end of the standard Blacklght SOLR
    # params method chain.  Note that in our deployments we tend to cache
    # controllers so this append to solr_search_params_logic must happen upon 
    # include and not inside the controller action.  Otherwise the 
    # solr_search_params_logic chaing will grow with each request.
        
    # Advanced searches require some extra params manipulation
    self.solr_search_params_logic << :advanced_search_processing
    
    self.solr_search_params_logic << :process_search_request
  end
    
  def advanced_search_processing( solr_parameters, user_params )
    return if user_params[ :search_mode ] != "advanced"
      
    # For now the q_* fields are processed the same for all search_types
    advanced_search_processing_q_fields( solr_parameters, user_params )
  end
  
  # This has to be defined in controller in order to be added to solr_search_params_logic
  def process_search_request( solr_parameters, user_params )
    @configurator.process_search_request( solr_parameters, user_params )
  end
  
end