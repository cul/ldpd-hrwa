# -*- encoding : utf-8 -*-
module Hrwa::MailHelper

  def send_mail(to, from, subject, body)
    Mailer.send_mail(to, from, subject, body).deliver
  end

  def send_mail_contact(to)

    # From form:
    #contact['text']
    #contact['name']
    #contact['email']

    # From request:
    #request.env['HTTP_USER_AGENT']

    message = ''

    message += "Name:\n" + (params[:contact]['name'].blank? ? 'blank' : params[:contact]['name']) + "\n\n"
    message += "Email:\n" + (params[:contact]['email'].blank? ? 'blank' : params[:contact]['email']) + "\n\n"
    message += "Message:\n" + (params[:contact]['message'].blank? ? 'blank' : params[:contact]['message']) + "\n\n"
    message += "URL:\n" + "http://#{request.host}:#{request.port.to_s + request.fullpath}" + "\n\n"

    send_mail(to, 'lindquist_contact@libraries.cul.columbia.edu', 'Lindquist Contact Form', message)
  end

  def send_mail_problem_report(to)

    # From form:
    #contact['text']
    #contact['name']
    #contact['email']

    # From request:
    #request.env['HTTP_USER_AGENT']

    message = ''

    message += "Name:\n" + (params[:problem_report]['name'].blank? ? 'blank' : params[:problem_report]['name']) + "\n\n"
    message += "Email:\n" + (params[:problem_report]['email'].blank? ? 'blank' : params[:problem_report]['email']) + "\n\n"
    message += "Message:\n" + (params[:problem_report]['message'].blank? ? 'blank' : params[:problem_report]['message']) + "\n\n"
    message += "URL:\n" + "http://#{request.host}:#{request.port.to_s + request.fullpath}" + "\n\n"

    send_mail(to, 'lindquist_problem_report@libraries.cul.columbia.edu', 'Lindquist Problem Report Form', message)
  end

end
