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


  # ! Override of default render_filter_element !
  #
  def render_filter_element(facet_or_filter, values, localized_params)
    values.map do |val|

      # If we're working with a filter rather than a facet, then
      # we need to use html_safe on the value of that filter.
      # Blacklight does this automatically for facets, but not filters.
      if facet_field_labels[facet_or_filter].nil?
        val = val.html_safe
        label = filter_field_labels[facet_or_filter]
      else
        label = facet_field_labels[facet_or_filter]
      end

      render_constraint_element( label,
                  val,
                  :remove => catalog_index_path(remove_facet_params(facet_or_filter, val, localized_params)),
                  :classes => ["filter", "filter-" + facet_or_filter.parameterize]
                ) + "\n"
    end
  end

  def filter_field_labels
    # Note 1: The method that this is based on (facet_field_labels) is DEPRECATED,
    # so that pretty much means that this method is deprecated too. No other options
    # at the moment though.

    # Note 2: Since the filter fields are supposed to mirror the facet field structure,
    # I'm deliberately building the hash below in a particular way.

    #Place ANY filters (that are not facets) in this method to make them appear as pills

    custom_filter_fields = {
                      # FSF

                      'title__facet' => {:label => 'Title'},
                      'creator_name__facet' => {:label => 'Creator Name'},
                      'original_urls' => {:label => 'Original Url'},

                      # ASF

                      # There are currently no ASF filters that aren't already facets
                    }

    custom_filter_fields.each do |key, value|
      value[:label] = value[:label].html_safe
    end

    return Hash[*custom_filter_fields.map { |key, filter| [key, filter[:label]] }.flatten]
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
