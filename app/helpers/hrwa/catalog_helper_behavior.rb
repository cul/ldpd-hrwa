# -*- encoding : utf-8 -*-
module HRWA::CatalogHelperBehavior
  # Override
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

  def formatted_highlighted_snippet (highlighted_snippets, prioritized_highlight_field_list)
    properly_ordered_snippet_array = Array.new

    prioritized_highlight_field_list.each do | field |
      if highlighted_snippets[field]
        properly_ordered_snippet_array << highlighted_snippets[field]
      end
    end

    return properly_ordered_snippet_array.join('...').html_safe
  end

end
