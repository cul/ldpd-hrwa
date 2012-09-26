# -*- encoding : utf-8 -*-
module Hrwa::CatalogHelperBehavior

  def facet_array_to_delimited_list_with_links(facet_fieldname, array_of_facets)

    html_to_return = '';

    array_of_facets.each{ |facet_value|
      html_to_return += '<a href="/catalog?search_type=find_site&f%5B'.html_safe + facet_fieldname + '%5D%5B%5D='.html_safe + facet_value + '">'.html_safe + h(facet_value) + '</a>; '.html_safe
    }

    #And then remove the final space and semicolon (" ;")

    html_to_return = html_to_return[0...html_to_return.length-2]

    return html_to_return.html_safe
  end

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
        when 1; "Displaying <b>1</b> #{h(entry_name)}".html_safe
        else;   "Displaying <b>all #{total_num}</b> #{entry_name.pluralize}".html_safe
        end
      else
        "Displaying #{h(entry_name.pluralize)} <b id=\"current_result_set_range\">#{start_num} - #{end_num}</b> of <b>#{total_num}</b>".html_safe
      end
  end

  # Custom HRWA variation of render_pagination_info for an unknown set of grouped archive results
  # Pass in an RSolr::Response. Displays the "showing X through Y of N" message.
  def render_archive_pagination_info(response, options = {})
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
        when 1; "Displaying <b id='search_result_count' data-actual-result-count='".html_safe + total_num + "'>1</b> #{h(entry_name)}".html_safe
        else;   "Displaying <b id='search_result_count' data-actual-result-count='".html_safe + total_num + "'>all</b> #{entry_name.pluralize}".html_safe
        end
      else
        "Displaying page #{current_page} for about <b id='search_result_count' data-actual-result-count='".html_safe + total_num + "'>".html_safe + round_result_to_closest_vague_number(total_num).to_s + "</b> #{h(entry_name.pluralize)}".html_safe
      end
  end

  # Number converter that rounds any number to a more vague number
  #
  def round_result_to_closest_vague_number(number_string_to_round)

    # Remove any possibly present commas in this number string
    real_number = number_string_to_round.gsub(',', '').to_i

    if(real_number < 10)
      degree_of_rounding = 1
    elsif(real_number < 100)
      degree_of_rounding = 10
    elsif(real_number < 1000)
      degree_of_rounding = 100
    else
      degree_of_rounding = 10**(real_number.to_s.length-2)
    end

    number_with_delimiter((((real_number).to_f/degree_of_rounding).to_f).round*degree_of_rounding, :delimiter => ',')


  end

  def has_search_parameters?
    params[:q] or !params[:f].blank? or !params[:search_field].blank?
  end

  # ! Override ! We don't really need this method to say "from your search",
  # since sometimes we're showing result that didn't come from a user actively
  # searching for something, and this wording might be confusing.
  #
  # Like  #render_pagination_info above, but for an individual
  # item show page. Displays "showing X of Y items" message. Actually takes
  # data from session though (not a great design).
  # Code should call this method rather than interrogating session directly,
  # because implementation of where this data is stored/retrieved may change.
  def item_page_entry_info
    "Showing item <b>#{session[:search][:counter].to_i} of #{format_num(session[:search][:total])}</b>.".html_safe
  end

  # Returns the current url without any capture-date-related params
  # i.e. - Removes :capture_start_date, :capture_end_date and :f['dateOfCaptureYYYY']
  def url_for_without_capture_date_params(url_params = params)

    #we're doing a deletion, so we want to dup url_params so as to avoid deleting anything from the real params hash
    url_params = url_params.dup
    url_params[:f] = url_params[:f] ? url_params[:f].dup : nil #Also need to dup :f hash (if it exists), since we might be modifying it

    #remove capture_start params
    url_params.delete(:capture_start_date)
    url_params.delete(:capture_end_date)

    return url_for(url_params)

  end

  # Returns the current url with an extra :f['domain'] added
  def url_for_added_domain_facet(domain_facet_value_to_add, url_params = params)

    #we're doing an addition, so we want to dup url_params so as to avoid deleting anything from the real params hash
    url_params = url_params.dup
    url_params[:f] = url_params[:f] ? url_params[:f].dup : nil #Also need to dup :f hash (if it exists), since we might be modifying it

    #add additional domain facet
    url_params[:f] = {} if url_params[:f].nil?
    url_params[:f]['domain'] = [] if url_params[:f]['domain'].nil?
    url_params[:f]['domain'] << domain_facet_value_to_add if ! url_params[:f]['domain'].include?(domain_facet_value_to_add)

    return url_for(url_params)

  end

  # Returns the current url with an added fq for excluding the specified domain
  def url_for_exclude_domain_addition(domain_to_exclude, url_params = params)

    #we're doing an addition, so we want to dup url_params so as to avoid deleting anything from the real params hash
    url_params = url_params.dup
    url_params[:f] = url_params[:f] ? url_params[:f].dup : nil #Also need to dup :f hash (if it exists), since we might be modifying it

    #add additional domain exclusion

    if(url_params[:excl_domain])
      url_params[:excl_domain] = url_params[:excl_domain].dup
    else
      url_params[:excl_domain] = []
    end

    url_params[:excl_domain] << domain_to_exclude if ! url_params[:excl_domain].include?(domain_to_exclude)

    return url_for(url_params)
  end

  # Returns the current url with the specified domain exclusion removed
  def url_for_exclude_domain_removal(domain_exclusion_to_remove, url_params = params)

    puts url_params[:excl_domain].inspect

    #we're doing an addition, so we want to dup url_params so as to avoid deleting anything from the real params hash
    url_params = url_params.dup
    url_params[:f] = url_params[:f] ? url_params[:f].dup : nil #Also need to dup :f hash (if it exists), since we might be modifying it

    #remove domain exclusion

    puts url_params[:excl_domain].inspect

    if(url_params[:excl_domain])
      url_params[:excl_domain] = url_params[:excl_domain].dup
    else
      url_params[:excl_domain] = []
    end

    puts url_params[:excl_domain].inspect

    url_params[:excl_domain].delete(domain_exclusion_to_remove)

    puts url_params[:excl_domain].inspect

    return url_for(url_params)
  end

end
