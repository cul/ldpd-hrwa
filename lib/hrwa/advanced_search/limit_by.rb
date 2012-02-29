# Mix in advanced search limit-by processing
module HRWA::AdvancedSearch::LimitBy
  
  def limit_by_user_params( user_parameters = params )
    return user_parameters.select { | param, value | param =~ /^lim_.*/ && ! value.empty? }
  end
  
  def add_limit_by_filter_queries_to_solr( solr_parameters, user_parameters = params )
    
  end
end