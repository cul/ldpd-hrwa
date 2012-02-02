# Mix in advanced search processing
module Hrwa::SolrHelper::AdvancedSearch
  def self.included base
    # Add q processing
    base.solr_search_params_logic << [ :process_q_and,
                                       :process_q_or,
                                       :process_q_phrase,
                                       :process_q_exclude, ]
  end  
  
  # solr_search_params_logic methods take two arguments
  # @param [Hash] solr_parameters a hash of parameters to be sent to Solr (via RSolr)
  # @param [Hash] user_parameters a hash of user-supplied parameters (often via `params`)  
  def process_q_and solr_parameters, user_parameters
    
  end
  
  def process_q_or solr_parameters, user_parameters
    
  end
  
  def process_q_phrase solr_parameters, user_parameters
    
  end
  
  def process_q_exclude solr_parameters, user_parameters
    
  end
  
end