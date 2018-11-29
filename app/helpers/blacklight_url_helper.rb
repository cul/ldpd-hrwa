module BlacklightUrlHelper
  include Blacklight::UrlHelperBehavior

  #link_to label, 'https://wayback.archive-it.org/1068/*/http://www.mahteso.org/',  { data: { :'context-href' => 'https://wayback.archive-it.org/1068/*/http://www.mahteso.org/' } }
  # link_to_document(doc, 'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a hash. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  # TODO: move this to the IndexPresenter
  def link_to_document(doc, field_or_opts = nil, opts={:counter => nil})
    if field_or_opts.is_a? Hash
      opts = field_or_opts
    else
      field = field_or_opts
    end

    field ||= document_show_link_field(doc)
    label = index_presenter(doc).label field, opts
    path = doc['allURL']
    data_path = "#{path}?counter=#{opts[:counter]}"
    link_to label, path,  { data: { :'context-href' => path } }
  end

end
