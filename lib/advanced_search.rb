# Mix in advanced search processing
module AdvancedSearch
 
  def self.included( base ) 
    # Build q param
    base.solr_search_params_logic << :process_q_and
    base.solr_search_params_logic << :process_q_or
    base.solr_search_params_logic << :process_q_phrase
    base.solr_search_params_logic << :process_q_exclude    
  end  
  
  # solr_search_params_logic methods take two arguments
  # @param [Hash] solr_parameters a hash of parameters to be sent to Solr (via RSolr)
  # @param [Hash] user_parameters a hash of user-supplied parameters (often via `params`) 
   
  def process_q_and solr_parameters, user_parameters    
    q_and_input_string = user_parameters[ :q_and ]
    
    # Early exit if q_and input is nil or all whitespace
    return if ! q_and_input_string
    return if q_and_input_string.match( '^\s*$')
    
    q_and_param        = q_and_input_string
                                 .split( /\s+/ )
                                 .map { |term| '+'.concat( term ) }
                                 .join( ' ' )
    if solr_parameters[ :q ]
      solr_parameters[ :q ] << ' ' + q_and_param
    else 
      solr_parameters[ :q ] = q_and_param
    end
  end
  
  def process_q_exclude solr_parameters, user_parameters
    solr_parameters[ :q ] << " -women's -rights -africa"
  end
  
  def process_q_or solr_parameters, user_parameters
    solr_parameters[ :q ] << " women's rights africa"
  end
  
  def process_q_phrase solr_parameters, user_parameters
    solr_parameters[ :q ] << %q{ "women's rights africa"}
  end
    
end
 