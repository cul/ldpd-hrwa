# Mix in advanced search limit-by processing
module HRWA::AdvancedSearch::LimitBy
     
  def limit_by_field_for_lim_param( lim_param )
    @limit_by_field_for_lim_param = {
      :lim_domain                => 'domain',
      :lim_mimetype              => 'mimetype',
      :lim_langauge              => 'language',
      :lim_geographic_focus      => 'geographic_focus',
      :lim_organization_type     => 'organization_type',
      :lim_organization_based_in => 'organization_based_in',
      :lim_creator_name          => 'creator_name',
    }
    return @limit_by_field_for_lim_param[ lim_param.to_sym ]
  end
  
  def limit_by_user_params( user_parameters = params )
    return user_parameters.select { | param, value | param =~ /^lim_.*/ && ! value.empty? }
  end
  
  # Modeled after similar methods in Blacklight::SolrHelper
  def add_limit_by_filter_queries_to_solr( solr_parameters = @extra_controller_params,
                                           user_parameters = params )
    # :fq, map from :lim_*.
    lim_params = limit_by_user_params 
    return if lim_params.empty?
    
    solr_parameters[ :fq ] ||= []
    lim_params.each_pair { | lim_param, value_list |
      value_list ||= []
      value_list = [ value_list ] unless value_list.respond_to? :each
      value_list.each { |value|
        limit_by_field = limit_by_field_for_lim_param( lim_param )
        solr_parameters[ :fq ] << limit_by_value_to_fq_string( limit_by_field, value)
      }
    }
  end
    
  ##
  # Convert a limit_by/value pair into a solr fq parameter
  def limit_by_value_to_fq_string( limit_by_field, value ) 
    case
      when ( value.is_a?( Integer ) or ( value.to_i.to_s == value if value.respond_to? :to_i ) )
        "#{ limit_by_field }:#{ value }"
      when ( value.is_a?( Float ) or ( value.to_f.to_s == value if value.respond_to? :to_f ) )
        "#{ limit_by_field }:#{ value }"
      when value.is_a?( Range )
        "#{ limit_by_field }:[ #{ value.first } TO #{ value.last } ]"
      else
        "#{ limit_by_field }:#{ value }"
    end
  end
  
end