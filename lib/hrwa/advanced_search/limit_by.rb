# Mix in advanced search limit-by processing
module HRWA::AdvancedSearch::LimitBy
  def add_limit_by_domain_to_fq( solr_parameters, user_parameters  )
    solr_parameters[ :fq ] ||= []
    domain = user_parameters[ :lim_domain ]
    solr_parameters[ :fq ] << "domain:#{ domain }"
  end
end