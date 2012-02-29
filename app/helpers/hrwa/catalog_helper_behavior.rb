# -*- encoding : utf-8 -*-
module HRWA::CatalogHelperBehavior

  def debug_link( url_params = params )
    if ( url_params.has_key?( :hrwa_debug ) )
      return debug_off_link( url_params )
    else
      return debug_on_link( url_params )
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

  #TODO: da217 - switch position of url_params and new_params so that when you later add html_options = {}, it will work as the last parameter

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

  def link_to_with_new_params( body, url_params = params, new_params )
    return link_to( body, search_path( url_params.merge( new_params ) ) )
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

  def link_to_add_additional_facet_to_current_url_unless_value_already_in_current_url(body, facet_type, facet_value, url_params = params, options ={})

    # First, check if this facet_type => facet_value combo is already in the current url
    # If so, return a non-clickable link
    if params.include?(:f) && params[:f].include?(facet_type) && params[:f][facet_type].include?(facet_value)
      return body
    else
      #otherwise return a link to add this facet to the current url
      return (link_to body, add_facet_params_and_redirect(facet_type, facet_value), options).html_safe
    end

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
