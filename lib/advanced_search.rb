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
    _process_q_prepend( solr_parameters, user_parameters, :q_and, '+' )
  end
  
  def process_q_exclude( solr_parameters, user_parameters )
    _process_q_prepend( solr_parameters, user_parameters, :q_exclude, '-' )
  end
  
  def process_q_or( solr_parameters, user_parameters )
    q_input_string = user_parameters[ :q_or ]
    return if ! _is_invalid_input?( q_input_string )
    
    _add_to_q_solr_param( solr_parameters, q_input_string )
  end
  
  def process_q_phrase( solr_parameters, user_parameters )
    q_input_string = user_parameters[ :q_phrase ]
    return if ! _is_invalid_input?( q_input_string )
    
    q_param = %q{"} + q_input_string + %q{"}
    
    _add_to_q_solr_param( solr_parameters, q_param )
  end
  
  private
  
  def _add_to_q_solr_param( solr_parameters, q_param )
    if solr_parameters[ :q ]
      solr_parameters[ :q ] << ' ' + q_param
    else 
      solr_parameters[ :q ] = q_param
    end
  end
  
  def _is_invalid_input?( q_input_string )
    return true if ! q_input_string
    return true if q_input_string.match( '^\s*$')
    return false
  end
  
  def _process_q_prepend( solr_parameters, user_parameters, param_name, prepend_string)
    q_input_string = user_parameters[ param_name ]
    return if ! _is_invalid_input?( q_input_string )
    
    q_param = q_input_string
                .split( /\s+/ )
                .map { |term| "#{prepend_string}#{term}" }
                .join( ' ' )
                
    _add_to_q_solr_param( solr_parameters, q_param )        
  end
    
end
 