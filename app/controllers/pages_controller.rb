# -*- encoding : utf-8 -*-

# This controller handles all requests static HTML pages
class PagesController < ApplicationController

  include Hrwa::MailHelper

  def about
  end

  def faq
  end

  def owner_nomination
  end

  def public_nomination
  end

  def terms_of_use
  end

  def contact
		if(params[:contact])
      send_mail_contact( 'lindquist_contact@libraries.cul.columbia.edu' )
      flash.now[:notice] = 'Thank you.  Your message has been submitted.'
		end
  end

  def problem_report
		if(params[:problem_report])
      send_mail_problem_report( 'lindquist_problem_report@libraries.cul.columbia.edu' )
      flash.now[:notice] = 'Thank you.  Your problem report has been submitted.'
		end
  end

end
