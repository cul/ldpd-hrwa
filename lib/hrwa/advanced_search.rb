# Mix in advanced search processing
module HRWA::AdvancedSearch
  
  def advanced_search_processing( extra_controller_params, configurator )
    # For now the q_* fields are processed the same for all search_types
    advanced_search_processing_q_fields( extra_controller_params, configurator )
    # Now for search-type-specific advanced search stuff
    @configurator.advanced_search_processing( extra_controller_params, params )
  end
  
  def advanced_search_processing_q_fields( extra_controller_params, configurator )
    # Advanced search form doesn't have a "q" textbox.  If there's anything in
    # user param q it shouldn't be there
    params[ :q ] = nil

    # Blacklight expects a 'q' SOLR param so we must build one from the q_* text params
    # Blacklight::SolrHelper#get_search_results takes optional extra_controller_params
    # hash that is merged into/overrides user_params
    process_q_type_params extra_controller_params, params

    params[ :q ] = extra_controller_params[ :q ]
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
    return if not valid_input?( user_parameters[ :q_or ] )
    
    add_to_q_solr_param( solr_parameters, user_parameters[ :q_or ] )
  end
  
  def process_q_phrase( solr_parameters, user_parameters )
    return if not valid_input?( user_parameters[ :q_phrase ] )
    
    add_to_q_solr_param( solr_parameters,
                         %q{"} + user_parameters[ :q_phrase ] + %q{"} )
  end
  
  def process_q_type_params( solr_parameters, user_parameters )
    process_q_and     solr_parameters, user_parameters
    process_q_exclude solr_parameters, user_parameters
    process_q_phrase  solr_parameters, user_parameters
    process_q_or      solr_parameters, user_parameters
  end
  
  private
  
  def add_to_q_solr_param( solr_parameters, q_param )
    if solr_parameters[ :q ]
      solr_parameters[ :q ] << ' ' + q_param
    else 
      solr_parameters[ :q ] = q_param
    end
  end
  
  def valid_input?( q_input_string )
    return false if ! q_input_string
    return false if q_input_string.match( '^\s*$')
    return true
  end
  
  def process_q_prepend( solr_parameters, user_parameters, param_name, prepend_string)
    return if not valid_input?( user_parameters[ param_name ] )
    
    q_param = user_parameters[ param_name ]
                .split( /\s+/ )
                .map { |term| "#{prepend_string}#{term}" }
                .join( ' ' )
                
    add_to_q_solr_param( solr_parameters, q_param )        
  end
    
end
 