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

     html_to_return = ''

      values = localized_params[:excl_domain] ? localized_params[:excl_domain].dup : []

      if(values.length > 0)
         values.each{|item|

            puts 'ITEMMMMM: ' + item

            options = {:remove => url_for_exclude_domain_removal(item), :classes => ["exclusion"]}
            removal_link_body = "<i class=\"icon-remove icon-white\"></i>Exclude Domain: ".html_safe + item
            html_to_return += link_to(
                           removal_link_body,
                           url_for_exclude_domain_removal(item),
                           :rel=>'tooltip', :title=>'Remove this filter', :class=>'btn btn-info btn-small facet-pill ' + (options[:classes].join(" ") if options[:classes]))

            html_to_return += ' '
         }
      end

      return html_to_return.html_safe

  end

end
