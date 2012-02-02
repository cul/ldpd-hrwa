# Mix in advanced search processing
module AdvancedSearch
  extend ActiveSupport::Concern
 
  included do 
    # Build q param
    self.solr_search_params_logic << :process_q_and
    self.solr_search_params_logic << :process_q_or
    self.solr_search_params_logic << :process_q_phrase
    self.solr_search_params_logic << :process_q_exclude    
  end  
  
  module ClassMethods
    # solr_search_params_logic methods take two arguments
    # @param [Hash] solr_parameters a hash of parameters to be sent to Solr (via RSolr)
    # @param [Hash] user_parameters a hash of user-supplied parameters (often via `params`) 
     
    def process_q_and solr_parameters, user_parameters
      solr_parameters[ :q ] << " +women's +rights +africa"
    end
    
    def process_q_or solr_parameters, user_parameters
      
    end
    
    def process_q_phrase solr_parameters, user_parameters
      
    end
    
    def process_q_exclude solr_parameters, user_parameters
      
    end
  end
end
 