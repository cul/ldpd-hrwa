# -*- encoding : utf-8 -*-
module HRWA::CatalogHelperBehavior
  
  def exclude_domain_from_hits_link( url_params = params, domain )
    return link_to_with_new_params_reverse_merge( %Q{Exclude "#{ domain }" from hits},
                                                  url_params,
                                                  { :'excl_domain' => domain }, )
  end 
  
  def see_all_hits_from_domain_link( url_params = params, domain )
    return link_to_with_new_params_reverse_merge( %Q{See all hits from "#{ domain }"},
                                    url_params,
                                    { :'f[domain][]' => domain },
                                  )
  end
  
  def link_to_with_new_params( body, url_params = params, new_params )
    return link_to( body, search_path( url_params.merge( new_params ) ) )
  end
  
  def link_to_with_new_params_reverse_merge( body, url_params = params, new_params )
    return link_to( body, search_path( url_params.reverse_merge( new_params ) ) )
  end
  
  # Unfortunately url_for creates a link using 'catalog?' instead of 'search?'
  # So we have to make our own helper method
  def rewritten_request_url_overwrite_params( new_params )
    rewritten_request_url = "#{ search_path }?"
    
    params_for_rewritten_url = params.dup
    params_for_rewritten_url.merge!( new_params )
    
    params_for_rewritten_url.each { | param_name, param_value |
      rewritten_request_url << "#{ param_name }=#{ param_value }&"
    }
    
    return rewritten_request_url.chop!
  end  
  
  # Overrides
  def has_search_parameters?
    if params[:search_mode] == 'advanced' 
      return( !params[:q_and].blank?     or 
              !params[:q_exclude].blank? or
              !params[:q_phrase].blank?  or
              !params[:q_not].blank?     or
              !params[:f].blank?         or 
              !params[:search_field].blank? )
    else
      super
    end
  end  
end