# -*- encoding : utf-8 -*-

# This controller handles administrative stuff
class AdminController < ApplicationController

  before_filter :authenticate_admin!

  def index
		if admin_signed_in?
			@admin_is_signed_in = true;
		else
			@admin_is_signed_in = false;
		end
  end

end
