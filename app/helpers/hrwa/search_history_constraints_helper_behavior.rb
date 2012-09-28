# -*- encoding : utf-8 -*-

module Hrwa::SearchHistoryConstraintsHelperBehavior

  # HRWA Note: Fix for displaying blank search queries
  def render_search_to_s_q(params)
    return "[Blank search query]".html_safe if params[:q].blank?

    label = (default_search_field && params[:search_field] == default_search_field[:key]) ?
      nil :
      label_for_search_field(params[:search_field])

    render_search_to_s_element(label , params[:q] )
  end

  # HRWA Note: Fix for displaying facet display names when they have not been
  # set in the configurator (using '::' instead of facet name)
  def render_search_to_s_filters(params)
    return "".html_safe unless params[:f]

    params[:f].collect do |facet_field, value_list|
      render_search_to_s_element('::',
        value_list.collect do |value|
          render_filter_value(value)
        end.join(content_tag(:span, 'and', :class =>'label')).html_safe
      )
    end.join(" \n ").html_safe
  end

end
