# -*- encoding : utf-8 -*-
module Hrwa::BrowseListRenderHelper

  include Hrwa::BrowseListHelper

  def render_browse_list(field_name, show_count=true)

    valid_field_types = [ 'title__facet',
                          'original_urls',
                          'subject__facet',
                          'geographic_focus__facet',
                          'language__facet' ]
    if( ! valid_field_types.include?(field_name) )
      Rails.logger.debug('Invalid field given to render_browse_list')
      return 'Invalid field'
    end

    # Dynamically calling one of the browse_list_for_ methods in BrowseListRenderHelper
    browse_list_hash = self.send( 'browse_list_for_' + field_name )

    html_to_return = ''

    if show_count
      browse_list_hash.each_pair{|item, sort_field|
        html_to_return += '<li><div>' + link_to(h(item), {:controller => 'catalog', :action => 'index', :q => '', :search_type => 'find_site', "f[#{field_name.html_safe}][]".html_safe => item}) + ' <span class="count">' + sort_field.to_s + '</span>' + '</div></li>'
      }
    else
      browse_list_hash.each_pair{|item, sort_field|
        html_to_return += '<li><div>' + link_to(h(item), {:controller => 'catalog', :action => 'index', :q => '', :search_type => 'find_site', "f[#{field_name.html_safe}][]".html_safe => item}) + '</div></li>'
      }
    end

    return html_to_return.html_safe

  end

end
