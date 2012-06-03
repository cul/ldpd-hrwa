# -*- encoding : utf-8 -*-

# This controller handles all requests static HTML pages
class StaticController < ApplicationController

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
			Mailer.send_mail('culhrweb-all@libraries.cul.columbia.edu', 'culhrweb-all@libraries.cul.columbia.edu', 'HRWA Public Feedback', 'Submitted Info: ' + params[:feedback].to_s).deliver
			flash.now[:notice] = 'Thank you for submitting your feedback.'
		end
  end

  def public_bugreports
		if(params[:bugReport])
			Mailer.send_mail('culhrweb-bugreports@libraries.cul.columbia.edu', 'culhrweb-bugreports@libraries.cul.columbia.edu', 'HRWA Public Bug Report', 'Submitted Info: ' + params[:bugReport].to_s).deliver
			flash.now[:notice] = 'Thank you for submitting a bug report.'
		end
  end

end
