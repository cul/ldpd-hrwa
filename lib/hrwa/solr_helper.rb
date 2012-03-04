# -*- encoding : utf-8 -*-
module HRWA::SolrHelper

  # ! Override of solr_doc_params !
  #
  # returns a params hash for finding a single solr document (CatalogController #show action)
  # If the id arg is nil, then the value is fetched from params[:id]
  # This method is primary called by the get_solr_response_for_doc_id method.
  def solr_doc_params(id=nil)

    id ||= params[:id]

    # elo2112 - Because of the way that I'm using id, you MUST make sure that it's numeric,
    # otherwise people would be able to inject whatever they want into the solr request url
    # The url looks like this:
    # http://harding.cul.columbia.edu:8080/solr-4/fsf/select?qt=search&q=<...whatever id equals ...>
    # See what I mean?  If id = 'fish', then you get:
    # http://harding.cul.columbia.edu:8080/solr-4/fsf/select?qt=search&q=fish
    # We don't want that.
    # So that's why we do this (below):
    id = id.to_i

    return {
      :qt => :search,
      :q => 'id:'+id.to_s # this assumes the document request handler will map the 'id' param to the unique key field
    }
  
  end

end
