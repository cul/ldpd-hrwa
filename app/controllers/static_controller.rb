# -*- encoding : utf-8 -*-

# This controller handles all requests static HTML pages
class StaticController < ApplicationController
  include HRWA::Static
  
  def about
  end

  def faq
  end

  def owner_nomination
  end

  def public_nomination
  end

  def collection_browse
  end

  def index
  end

  def public_feedback
		if(params[:feedback])
      send_public_feedback( 'da217@columbia.edu' )
      flash.now[:notice] = 'Thank you for submitting your feedback'
		end
  end

  def public_bugreports
		if(params[:bugReport])
      send_bug_report( 'da217@columbia.edu' )
      flash.now[:notice] = 'Thank you for submitting a bug report.'
		end
  end

end
