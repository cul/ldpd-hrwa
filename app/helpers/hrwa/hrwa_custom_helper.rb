require 'nokogiri'

# -*- encoding : utf-8 -*-
module Hrwa::HrwaCustomHelper

  def formatted_highlighted_snippet (highlighted_snippets, prioritized_highlight_field_list)
    properly_ordered_snippet_array = Array.new

    prioritized_highlight_field_list.each do | field |
      if highlighted_snippets[field]
        properly_ordered_snippet_array << highlighted_snippets[field]
      end
    end

    joined_snippet = properly_ordered_snippet_array.join('...')

    if(joined_snippet.length > 0)

      code_opening_tag_placeholder = '||||CODE-START||||'
      code_closing_tag_placeholder = '||||CODE-END||||'

      return (Nokogiri::HTML(properly_ordered_snippet_array.join('...').gsub('<code>', code_opening_tag_placeholder).gsub('</code>', code_closing_tag_placeholder) + '...').text).gsub(code_opening_tag_placeholder, '<code>').gsub(code_closing_tag_placeholder, '</code>').html_safe
    else
      return ''
    end

  end

end
