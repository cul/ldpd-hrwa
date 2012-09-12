module Hrwa::FacetsHelperBehavior

  #
  # facet param helpers ->
  #

  # Standard display of a facet value in a list. Used in both _facets sidebar
  # partial and catalog/facet expanded list. Will output facet value name as
  # a link to add that to your restrictions, with count in parens.
  # first arg item is a facet value item from rsolr-ext.
  # options consist of:
  # :suppress_link => true # do not make it a link, used for an already selected value for instance
  def render_facet_value(facet_solr_field, item, options ={})
    (link_to_unless(options[:suppress_link], item.value, add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") + " " + render_facet_count(item.hits)).html_safe
  end

  # Standard display of a SELECTED facet value, no link, special span
  # with class, and 'remove' button.
  def render_selected_facet_value(facet_solr_field, item)
    content_tag(:span, render_facet_value(facet_solr_field, item, :suppress_link => true)) +
      link_to("[x]", remove_facet_params(facet_solr_field, item.value, params), :class=>"remove", :rel => 'tooltip', :'data-original-title' => 'Remove this facet')
  end

end
