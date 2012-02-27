# -*- encoding : utf-8 -*-
module HRWA::CatalogHelperBehavior

  def debug_link( url_params = params )
    if ( url_params.has_key?( :hrwa_debug ) )
      return debug_off_link
    else
      return debug_on_link
    end
  end

  def debug_off_link( url_params = params )
    link_to_delete_params( 'Debug off', url_params, [ :hrwa_debug ] )
  end

  def debug_on_link( url_params = params )
    link_to_with_new_params_reverse_merge( 'Debug on', url_params, :hrwa_debug => true )
  end

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
  
  def link_to_delete_params( body, url_params = params, params_to_delete )
    params_to_delete.each { | key |
      url_params.delete( key )
    }
    return link_to( body, search_path( url_params ) )
  end

  def formatted_highlighted_snippet (highlighted_snippets, prioritized_highlight_field_list)
    properly_ordered_snippet_array = Array.new

    prioritized_highlight_field_list.each do | field |
      if highlighted_snippets[field]
        properly_ordered_snippet_array << highlighted_snippets[field]
      end
    end

    return properly_ordered_snippet_array.join('...').html_safe
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
