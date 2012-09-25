# -*- encoding : utf-8 -*-

# This controller handles all requests static HTML pages
class PagesController < ApplicationController

  include Hrwa::MailHelper

  def about
  end

  def faq
  end

  def owner_nomination
		if(params[:owner_nomination])
      send_mail_owner_nomination( 'elo2112@libraries.cul.columbia.edu' )
      flash.now[:notice] = 'Thank you.  Your nomination has been submitted.'
		end
  end

  def public_nomination
		if(params[:public_nomination])
      send_mail_public_nomination( 'elo2112@libraries.cul.columbia.edu' )
      flash.now[:notice] = 'Thank you.  Your nomination has been submitted.'
		end
  end

  def terms_of_use
  end

  def contact
		if(params[:contact])
      send_mail_contact( 'elo2112@libraries.cul.columbia.edu' )
      flash.now[:notice] = 'Thank you.  Your message has been submitted.'
		end
  end

  def problem_report
		if(params[:problem_report])
      send_mail_problem_report( 'elo2112@libraries.cul.columbia.edu' )
      flash.now[:notice] = 'Thank you.  Your problem report has been submitted.'
		end
  end

end
