# -*- encoding : utf-8 -*-
# All methods in here are 'api' that may be over-ridden by plugins and local
# code, so method signatures and semantics should not be changed casually.
# implementations can be of course.
#
# Includes methods for rendering contraints graphically on the
# search results page (render_constraints(_*))
module Hrwa::RenderConstraintsHelperBehavior

  # Render actual constraints, not including header or footer
  # info.
  def render_constraints(localized_params = params)
     render_constraints_filters(localized_params) + render_capture_date_filters(localized_params) + ' ' + render_excl_domain_filters(localized_params)
  end

  #TODO: Don't do direct html rendering using link_to.  Use a shared partial instead (catalog/constraints_element).
  def render_capture_date_filters(localized_params = params)

    capture_start_date = localized_params[:capture_start_date].blank? ? nil : localized_params[:capture_start_date]
    capture_end_date = localized_params[:capture_end_date].blank? ? nil : localized_params[:capture_end_date]

    if(capture_start_date || capture_end_date)

        capture_date_range_string = '';

        if(capture_start_date && capture_end_date)
            capture_date_range_string = "#{capture_start_date} - #{capture_end_date}"
        elsif(capture_start_date && !capture_end_date)
            capture_date_range_string = "After #{capture_start_date}"
        elsif(!capture_start_date && capture_end_date)
            capture_date_range_string = "Before #{capture_end_date}"
        end

        options = {:remove => url_for_without_capture_date_params, :classes => ["capture_date"]}
        removal_link_body = "<i class=\"icon-remove icon-white\"></i>Date Of Capture Range: ".html_safe + capture_date_range_string
        return link_to(
                        removal_link_body,
                        options[:remove],
                        :rel=>'tooltip', :title=>'Remove this filter', :class=>'btn btn-info btn-small facet-pill ' + (options[:classes].join(" ") if options[:classes]))

    end

  end





  #TODO: Don't do direct html rendering using link_to.  Use a shared partial instead (catalog/constraints_element).
  def render_excl_domain_filters(localized_params = params)

    values = localized_params[:excl_domain] ? localized_params[:excl_domain].dup : nil

    if(values)
       values.map do |value|

            options = {:remove => remove_excl_domain_filter(value), :classes => ["exclusion"]}
            removal_link_body = "<i class=\"icon-remove icon-white\"></i> Excluding: ".html_safe + value
            return link_to(
                            removal_link_body,
                            options[:remove],
                            :rel=>'tooltip', :title=>'Remove this filter', :class=>'btn btn-info btn-small facet-pill ' + (options[:classes].join(" ") if options[:classes]))

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

end
