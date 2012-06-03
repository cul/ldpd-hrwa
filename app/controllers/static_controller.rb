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
		#<input type="hidden" value="HRWA Public Feedback: $$" name="subject">
		#<input type="hidden" class="culhrweb-all" value="#" name="mail_dest">
		#<input type="hidden" value="true" name="echo_data">
		
		if(params[:submit])
			Mailer.send_mail('elo2112@columbia.edu', 'elo2112@columbia.edu', 'Test!', 'The latest and greatest in email technology!').deliver
		end
  end

  def public_bugreports
		
		#<input type="hidden" value="(none)" name="http_referer">
		#<input type="hidden" value="HRWA Public Bug Report: $$" name="subject">
		#<input type="hidden" class="culhrweb-bugreports" value="#" name="mail_dest">
		#<input type="hidden" value="true" name="echo_data">
		
		if(params[:submit])
			Mailer.send_mail('elo2112@columbia.edu', 'elo2112@columbia.edu', 'Test!', 'The latest and greatest in email technology!').deliver
		end
  end

end
