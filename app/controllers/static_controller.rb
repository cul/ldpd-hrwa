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

      params[:feedback]['IP Address'] = request.remote_ip;
      current_time = Time.new
      params[:feedback]['Timestamp'] = current_time.to_time.to_s + ' (' + current_time.to_time.to_i.to_s + ')';

      email_body = '';

      params[:feedback].each_pair { |key, value|
        email_body += "#{key}: #{value}\n\n"
      }

			Mailer.send_mail('culhrweb-all@libraries.cul.columbia.edu', 'culhrweb-all@libraries.cul.columbia.edu', 'HRWA Public Feedback', email_body).deliver
			flash.now[:notice] = 'Thank you for submitting your feedback.'
		end
  end

  def public_bugreports
		if(params[:bugReport])

      params[:bugReport]['IP Address'] = request.remote_ip;
      current_time = Time.new
      params[:bugReport]['Timestamp'] = current_time.to_time.to_s + '(' + current_time.to_time.to_i.to_s + ')';

      email_body = '';

      params[:bugReport].each_pair { |key, value|
        email_body += "#{key}: #{value}\n\n"
      }

			Mailer.send_mail('culhrweb-bugreports@libraries.cul.columbia.edu', 'culhrweb-bugreports@libraries.cul.columbia.edu', 'HRWA Public Bug Report', email_body).deliver
			flash.now[:notice] = 'Thank you for submitting a bug report.'
		end
  end

end
