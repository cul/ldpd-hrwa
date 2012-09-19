# -*- encoding : utf-8 -*-
module Hrwa::CatalogHelperBehavior

  def facet_array_to_delimited_list_with_links(facet_fieldname, array_of_facets)

    html_to_return = '';

    array_of_facets.each{ |facet_value|
      html_to_return += '<a href="/catalog?f%5B'.html_safe + facet_fieldname + '%5D%5B%5D='.html_safe + facet_value + '">'.html_safe + h(facet_value) + '</a>; '.html_safe
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
        when 1; "Displaying <b>1</b> #{h(entry_name)}".html_safe
        else;   "Displaying <b>all</b> #{entry_name.pluralize}".html_safe
        end
      else
        "Displaying page #{current_page} of about <b>".html_safe + round_result_to_closest_vague_number(total_num).to_s + "</b> #{h(entry_name.pluralize)}".html_safe
      end
  end

  # Number converter that rounds any number to a more vague number
  #
  def round_result_to_closest_vague_number(number_string_to_round)

    # Remove any possibly present commas in this number string
    real_number = number_string_to_round.gsub(',', '').to_i

    if(real_number < 1000)
      degree_of_rounding = 100
    else
      degree_of_rounding = 10**(real_number.to_s.length-2)
      puts 'degree_of_roundingggggggggggggggggggggggggg: ' + degree_of_rounding.to_s
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

end
