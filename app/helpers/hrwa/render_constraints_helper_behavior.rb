module HRWA::RenderConstraintsHelperBehavior
  include Blacklight::RenderConstraintsHelperBehavior

  # ! Override of default render_constraints !
  # Removed query rendering as a facet pill: render_constraints_query(localized_params)
  #
  # Render actual constraints, not including header or footer
  # info.
  def render_constraints(localized_params = params)
    (render_constraints_filters(localized_params) + render_exclude_filters(localized_params)).html_safe
  end

  #TODO: Display exclusion filter as sub-search-bar "pills"
  def render_exclude_filters(localized_params = params)
    #content << render_exclude_element('excl_domain', localized_params[:excl_domain], localized_params)
    return ''.html_safe
  end
=begin
  #Custom method
  def render_exclude_element(exclusion_facet, values, localized_params)

    # Custom code time!  Add domain exclusion filter:
    # TODO: Later, we should probably move all exlucsion filters into their
    #% hash (like params[:f] for facets, we could do params[:excl])
    content << render_exclude_element('excl_domain', localized_params[:excl_domain], localized_params)

    values.map do |val|
      render_constraint_element( exclusion_facet,
                  val,
                  :remove => catalog_index_path(remove_facet_params(exclusion_facet, val, localized_params)),
                  :classes => ["filter", "filter-" + exclusion_facet.parameterize]
                ) + "\n"
    end
  end
=end

end
