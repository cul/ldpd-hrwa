module HRWA::RenderConstraintsHelperBehavior
  include Blacklight::RenderConstraintsHelperBehavior

  # ! Override of default render_constraints !
  # Removed query rendering as a facet pill: render_constraints_query(localized_params)
  #
  # Render actual constraints, not including header or footer
  # info.
  def render_constraints(localized_params = params)
    render_constraints_filters(localized_params) + render_excl_domain_filters(localized_params) + render_capture_date_filters(localized_params)
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





  #TODO: Don't do direct html rendering using link_to.  Use a shared partial instead (catalog/constraints_element).
  def render_excl_domain_filters(localized_params = params)

    values = localized_params[:excl_domain] ? localized_params[:excl_domain].dup : nil

    if(values)
       values.map do |value|

            options = {:remove => remove_excl_domain_filter(value), :classes => ["exclusion"]}
            removal_link_body = "[x] Excluding: #{value}"
            return link_to(
                            removal_link_body,
                            options[:remove],
                            :rel=>'tooltip', :title=>'Remove this filter', :class=>'delfq btn small ' + (options[:classes].join(" ") if options[:classes]))

        end
    end

  end

  # Based on the remove_facet_params method in facets_helper_behavior.rb
  def remove_excl_domain_filter(domain_value_to_remove, source_params = params)
    p = source_params.dup

    p[:excl_domain] = (p[:excl_domain] || []).dup
    p.delete :page
    p.delete :id
    p.delete :counter
    p.delete :commit
    p[:excl_domain] = p[:excl_domain] - [domain_value_to_remove]
    p.delete(:excl_domain) if p[:excl_domain].size == 0

    return p
  end





  #TODO: Don't do direct html rendering using link_to.  Use a shared partial instead (catalog/constraints_element).
  def render_capture_date_filters(localized_params = params)

    capture_start_date = localized_params[:capture_start_date].blank? ? nil : localized_params[:capture_start_date]
    capture_end_date = localized_params[:capture_end_date].blank? ? nil : localized_params[:capture_end_date]

    if(capture_start_date || capture_end_date)

        capture_date_range_sting = 'zzzzzzzzzz';

        if(capture_start_date && capture_end_date)
            capture_date_range_sting = "#{capture_start_date} - #{capture_end_date}"
        elsif(capture_start_date && !capture_end_date)
            capture_date_range_sting = "After #{capture_start_date}"
        elsif(!capture_start_date && capture_end_date)
            capture_date_range_sting = "Before #{capture_end_date}"
        end

        options = {:remove => url_for_without_capture_date_params, :classes => ["capture_date"]}
        removal_link_body = "Date Of Capture Range: #{capture_date_range_sting}"
        return link_to(
                        removal_link_body,
                        options[:remove],
                        :rel=>'tooltip', :title=>'Remove this filter', :class=>'delfq btn small ' + (options[:classes].join(" ") if options[:classes]))

    end

  end

end
