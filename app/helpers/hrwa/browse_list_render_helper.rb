# -*- encoding : utf-8 -*-
module Hrwa::BrowseListRenderHelper

  include Hrwa::BrowseListHelper

  def render_browse_list(field_name)

    valid_field_types = ['subject_geographic__facet', 'topic_subject__facet', 'associated_name__facet', 'subject_name__facet']
    if( ! valid_field_types.include?(field_name) )
      Rails.logger.debug('Invalid field given to render_browse_list')
      return 'Invalid field'
    end

    # Dynamically calling one of the browse_list_for_ methods in BrowseListRenderHelper
    browse_list_hash = self.send( 'browse_list_for_' + field_name )

    html_to_return = ''

    browse_list_hash.each_pair{|item, sort_field|
      html_to_return += '<li><div><a href="/catalog?f%5B' + field_name + '%5D%5B%5D=' + item + '">' + h(item) +  '</a> <span class="count">' + sort_field.to_s + '</span></div></li>'
    }

    return html_to_return.html_safe

  end

end
