# -*- encoding : utf-8 -*-

# This controller handles all requests static HTML pages
class PagesController < ApplicationController

  include Hrwa::MailHelper

  def about_the_collection
  end

  def about_gee_lindquist
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

  def faces
  end

end
