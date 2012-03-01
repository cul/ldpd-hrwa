module HRWA::RenderConstraintsHelperBehavior
  include Blacklight::RenderConstraintsHelperBehavior

  # ! Override of default render_constraints !
  #
  # Render actual constraints, not including header or footer
  # info.
  def render_constraints(localized_params = params)
    (render_constraints_query(localized_params) + render_constraints_filters(localized_params)).html_safe
  end

end
