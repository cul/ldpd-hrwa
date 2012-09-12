# -*- encoding : utf-8 -*-
#
# Methods added to this helper will be available to all templates in the hosting application
#
module Hrwa::CitationHelper

  def get_chicago_citation_for_document(document)

    item_permalink_url = ('http://' + request.host + (request.port == 80 ? '' : ':' + request.port.to_s) + catalog_path({:id => document.get('id')})).html_safe
    date_accessed_string = Date.today.strftime("%d %b %Y")

    citation_string = '<strong>Chicago:</strong><br />' + document.get('item_title') + ', MRL 10: G.E.E. Lindquist Papers, ' + document.get('box_number').to_s + ', ' + document.get('item_number').to_s + ', The Burke Library Archives (Columbia University Libraries) at Union Theological Seminary, New York. Can be viewed at ' + link_to(item_permalink_url, item_permalink_url) + '. Web accessed ' + date_accessed_string + '.'

    return citation_string.html_safe
  end

end
