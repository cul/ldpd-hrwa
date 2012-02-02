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
   
  def process_q_and( solr_parameters, user_parameters )    
    process_q_prepend( solr_parameters, user_parameters, :q_and, '+' )
  end
  
  def process_q_exclude( solr_parameters, user_parameters )
    process_q_prepend( solr_parameters, user_parameters, :q_exclude, '-' )
  end
  
  def process_q_or( solr_parameters, user_parameters )
    q_input_string = user_parameters[ :q_or ]
    
    # Early exit if q_and input is nil or all whitespace
    return if ! q_input_string
    return if q_input_string.match( '^\s*$')
    
    if solr_parameters[ :q ]
      solr_parameters[ :q ] << ' ' + q_input_string
    else 
      solr_parameters[ :q ] = q_input_string
    end
  end
  
  def process_q_phrase( solr_parameters, user_parameters )
    solr_parameters[ :q ] << %q{ "women's rights africa"}
  end
  
  def process_q_prepend( solr_parameters, user_parameters, param_name, prepend_string)
    q_input_string = user_parameters[ param_name ]
    
    # Early exit if q_and input is nil or all whitespace
    return if ! q_input_string
    return if q_input_string.match( '^\s*$')
    
    q_param = q_input_string
                .split( /\s+/ )
                .map { |term| "#{prepend_string}#{term}" }
                .join( ' ' )
    if solr_parameters[ :q ]
      solr_parameters[ :q ] << ' ' + q_param
    else 
      solr_parameters[ :q ] = q_param
    end
  end
    
end
 