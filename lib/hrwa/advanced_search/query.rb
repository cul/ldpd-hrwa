# Mix in advanced search processing
module HRWA::AdvancedSearch::Query

  def advanced_search_processing_q_fields( solr_parameters, user_params )
# debugger
    # Advanced search form doesn't have a "q" textbox.  If there's anything in
    # user param q it shouldn't be there
    user_params[ :q ]     = nil
    solr_parameters[ :q ] = nil

    # Blacklight expects a 'q' SOLR param so we must build one from the q_* text params
    # Blacklight::SolrHelper#get_search_results takes optional extra_controller_params
    # hash that is merged into/overrides user_params
    process_q_type_params solr_parameters, user_params

    # Now use interpreted advanced search as user param q for echo purposes
    user_params[ :q ] = solr_parameters[ :q ]
  end

  # solr_search_params_logic methods take two arguments
  # @param [Hash] solr_parameters a hash of parameters to be sent to Solr (via RSolr)
  # @param [Hash] user_params a hash of user-supplied parameters (often via `params`)

  def process_q_and( solr_parameters, user_params )
    process_q_prepend( solr_parameters, user_params, :q_and, '+' )
  end

  def process_q_exclude( solr_parameters, user_params )
    process_q_prepend( solr_parameters, user_params, :q_exclude, '-' )
  end

  def process_q_or( solr_parameters, user_params )
    return if not valid_input?( user_params[ :q_or ] )

    add_to_q_solr_param( solr_parameters, user_params[ :q_or ] )
  end

  def process_q_phrase( solr_parameters, user_params )
    return if not valid_input?( user_params[ :q_phrase ] )

    add_to_q_solr_param( solr_parameters,
                         %q{"} + user_params[ :q_phrase ] + %q{"} )
  end

  def process_q_type_params( solr_parameters, user_params )
    process_q_and     solr_parameters, user_params
    process_q_phrase  solr_parameters, user_params
    process_q_or      solr_parameters, user_params
    process_q_exclude solr_parameters, user_params
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

  def process_q_prepend( solr_parameters, user_params, param_name, prepend_string)
    return if not valid_input?( user_params[ param_name ] )

    q_param = user_params[ param_name ]
                .split( /\s+/ )
                .map { |term| "#{prepend_string}#{term}" }
                .join( ' ' )

    add_to_q_solr_param( solr_parameters, q_param )
  end
end
