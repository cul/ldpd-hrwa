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
     render_constraints_filters(localized_params).html_safe
  end

end
