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
      return properly_ordered_snippet_array.join('...').html_safe + '...'.html_safe
    else
      return ''
    end

  end

end
