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
    link_to_delete_params( 'Turn debug off', [ :hrwa_debug ], url_params )
  end

  def debug_on_link( url_params = params )
    link_to_with_new_params_reverse_merge( 'Turn debug on', url_params, :hrwa_debug => true )
  end

  def exclude_domain_from_hits_link( domain, url_params = params, html_options = {} )
    current_excluded_domains = url_params[ :excl_domain ].nil? ? nil : url_params[ :excl_domain ].dup

    # The '[]' may or may not have been appended to the param name -- TODO: Determine why this happens.  Does it still happen?  It doesn't seem like it ever does.
    #current_excluded_domains ||= url_params[ :'excl_domain[]' ]

    if ! current_excluded_domains
      # Note that we add :'excl_domain' and not :'excl_domain[]' because the link_to
      # helper that we will be using later will automatically append '[]' to the end,
      # so we want to avoid doubling.  This behavior is expected because excl_domain
      # is an array and inputs that hold arrays of data (as opposed to strings) indicate
      # this by appending '[]' to the end of the name="" attribute of the input.
      # (e.g. name="excl_domain[]")
      return link_to_with_new_params_reverse_merge( 'Domain-',
                                                    { :'excl_domain' => [ domain ] },
                                                    url_params,
                                                    html_options.merge({:rel => 'tooltip', :'data-original-title' => %Q{Exclude #{ domain } from results}})
                                                  )
    end

    if current_excluded_domains.class != Array
      current_excluded_domains = [ current_excluded_domains ]
    end

    if current_excluded_domains.include?( domain )
      excluded_domains = current_excluded_domains
    else
      excluded_domains = current_excluded_domains.push( domain )
    end

    # We will be adding :'excl_domain', not :'excl_domain[]' which is the name of the
    # param after it has been processed by the link_to helper.  So to prevent the
    # merge from inadvertently doubling the domain exclusion we remove the current
    # :'excl_domain[]' param, knowing that our :'excl_domain' will be renamed to that
    # after the merge and link_to call.
    #url_params.delete( :'excl_domain[]' )
    return link_to_with_new_params( 'Domain-',
                                    { :'excl_domain' => excluded_domains },
                                    url_params,
                                    html_options.merge({:rel => 'tooltip', :'data-original-title' => %Q{Exclude #{ domain } from results}})
                                  )
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

  def link_to_delete_params( body, params_to_delete, url_params = params, html_options = {} )
    url_params_copy = url_params.dup
    params_to_delete.each { | key |
      url_params_copy.delete( key )
    }
    return link_to( body, search_path( url_params_copy ), html_options )
  end

  #TODO: da217 - switch position of url_params and new_params so that when you later add html_options = {}, it will work as the last parameter

  def link_to_with_new_params( body, new_params, url_params = params, html_options ={} )
    return link_to( body, search_path( url_params.merge( new_params ) ), html_options )
  end

  def link_to_with_new_params_reverse_merge( body, new_params, url_params = params, html_options = {} )
    return link_to( body, search_path( url_params.reverse_merge( new_params ) ), html_options )
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

  # Returns the current url without any capture-date-related params
  # i.e. - Removes :capture_start_date, :capture_end_date and :f['dateOfCaptureYYYY']
  def url_for_without_capture_date_params(url_params = params)

    #we're doing a deletion, so we want to dup url_params so as to avoid deleting anything from the real params hash
    url_params = url_params.dup

    #remove capture_start params
    url_params.delete(:capture_start_date)
    url_params.delete(:capture_end_date)
    # also remove url_params[:f]['dateOfCaptureYYYY']
    url_params[:f].delete('dateOfCaptureYYYY') unless url_params[:f].nil?

    return url_for(url_params)

  end

  def generate_comma_delimited_facet_list(facet_name_array, facet_type, facet_value_array, as_links = false)

    #If strings are supplied rather than arrays, turn the strings into one-element arrays
    if facet_name_array.is_a?(String)
      facet_name_array = [facet_name_array]
    end

    if facet_value_array.is_a?(String)
      facet_value_array = [facet_value_array]
    end

		final_list = [];

    facet_name_array.each_index do |index|
      if as_links
        final_list << link_to_add_additional_facet_to_current_url_unless_value_already_in_current_url(facet_name_array[index], facet_type, facet_value_array[index])
      elsif
        final_list << facet_name_array[index]
      end
    end

    return final_list.join(', ').html_safe;

  end

  # ! Override of has_search_parameters? !
  def has_search_parameters?
    !params[:search].blank?
  end

  def see_all_hits_from_domain_link( domain, url_params = params, html_options = {})

    return link_to_with_new_params_reverse_merge( 'Domain+',
                                    { :'f[domain][]' => domain },
                                    url_params,
                                    html_options.merge({:rel => 'tooltip', :'data-original-title' => %Q{See all results from #{ domain }}})
                                  )
  end


  def get_specific_search_weight_from_weighting_string(search_weight_type, weighting_string)

    if(
        weighting_string.empty? ||
        weighting_string.index(search_weight_type).nil? ||
        (search_weight_type.length + 1) > weighting_string.length
      )
      return nil
    end

    start_of_numeric_value_index = (weighting_string.index(search_weight_type) + search_weight_type.length) + 1
    end_of_numeric_value_index = (weighting_string.index(/\D/, start_of_numeric_value_index))

    if(end_of_numeric_value_index.nil?)
      #this number was found at the end of the weighting_string
      numeric_value = weighting_string[start_of_numeric_value_index..weighting_string.length]
    else
      numeric_value = weighting_string[start_of_numeric_value_index..end_of_numeric_value_index]
    end

    return numeric_value.to_i unless numeric_value.to_i == 0 # because if numeric_value.to_i == 0, that means that no valid numeric value was supplied for the search_weight_type

  end

  # ! Override of render_pagination_info !
  #
  # Pass in an RSolr::Response. Displays the "showing X through Y of N" message.
  def render_pagination_info(response, options = {})
      start = response.start + 1
      per_page = response.rows
      current_page = (response.start / per_page).ceil + 1
      num_pages = (response.total / per_page.to_f).ceil
      total_hits = response.total

      start_num = format_num(start)
      end_num = format_num(start + response.docs.length - 1)
      total_num = format_num(total_hits)

      entry_name = options[:entry_name] ||
        (response.empty?? 'entry' : response.docs.first.class.name.underscore.sub('_', ' '))

      if num_pages < 2
        case response.docs.length
        when 0; "No #{h(entry_name.pluralize)} found".html_safe
        when 1; "Displaying <b>1</b>".html_safe + (@configurator.name == 'archive' ? ' grouped ' : ' ').html_safe + "#{h(entry_name)}".html_safe
        else;   "Displaying <b>all #{total_num}</b>".html_safe + (@configurator.name == 'archive' ? ' grouped ' : ' ').html_safe + "#{entry_name.pluralize}".html_safe
        end
      else
        "Displaying".html_safe + (@configurator.name == 'archive' ? ' grouped ' : ' ').html_safe + "#{h(entry_name.pluralize)} <b>#{start_num} - #{end_num}</b> of <b>#{total_num}</b>".html_safe
      end
  end

end
