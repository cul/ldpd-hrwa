# -*- encoding : utf-8 -*-

# This controller handles administrative stuff
class AdminController < ApplicationController

  before_filter :authenticate_admin!

  def index
		
  end

end
