# -*- encoding : utf-8 -*-
module Hrwa::MailHelper

  def send_mail(to, from, subject, body)
    Mailer.send_mail(to, from, subject, body).deliver
  end

  def send_mail_contact(to)

    # From request:
    #request.env['HTTP_USER_AGENT']

    message = ''

    message += "Name:\n" + (params[:contact]['name'].blank? ? 'blank' : params[:contact]['name']) + "\n\n"
    message += "Email:\n" + (params[:contact]['email'].blank? ? 'blank' : params[:contact]['email']) + "\n\n"
    message += "Message:\n" + (params[:contact]['message'].blank? ? 'blank' : params[:contact]['message']) + "\n\n"

    message += "Form URL:\n" + "http://#{request.host}:#{request.port.to_s + request.fullpath}" + "\n\n"

    send_mail(to, 'hrwa-developers@libraries.cul.columbia.edu', 'HRWA Contact Form', message)
  end

  def send_mail_problem_report(to)

    # From request:
    #request.env['HTTP_USER_AGENT']

    message = ''

    message += "Name:\n" + (params[:problem_report]['name'].blank? ? 'blank' : params[:problem_report]['name']) + "\n\n"
    message += "Email:\n" + (params[:problem_report]['email'].blank? ? 'blank' : params[:problem_report]['email']) + "\n\n"
    message += "Message:\n" + (params[:problem_report]['message'].blank? ? 'blank' : params[:problem_report]['message']) + "\n\n"

    message += "Form URL:\n" + "http://#{request.host}:#{request.port.to_s + request.fullpath}" + "\n\n"

    send_mail(to, 'hrwa-developers@libraries.cul.columbia.edu', 'HRWA Problem Report Form', message)
  end

  def send_mail_owner_nomination(to)
    # From request:
    #request.env['HTTP_USER_AGENT']

    message = ''

    message += "Name of website/organization:\n" + (params[:owner_nomination]['SiteName'].blank? ? 'blank' : params[:owner_nomination]['SiteName']) + "\n\n"
    message += "URL of website:\n" + (params[:owner_nomination]['URL'].blank? ? 'blank' : params[:owner_nomination]['URL']) + "\n\n"
    message += "Description of website/organization:\n" + (params[:owner_nomination]['Description'].blank? ? 'blank' : params[:owner_nomination]['Description']) + "\n\n"
    message += "Additional Information:\n" + (params[:owner_nomination]['AdditionalInformation'].blank? ? 'blank' : params[:owner_nomination]['AdditionalInformation']) + "\n\n"
    message += "Permissions:\n" + (params[:owner_nomination]['Permissions'].blank? ? 'blank' : params[:owner_nomination]['Permissions']) + "\n\n"

    message += "Contact Name:\n" + (params[:owner_nomination]['ContactName'].blank? ? 'blank' : params[:owner_nomination]['ContactName']) + "\n\n"
    message += "Contact Title:\n" + (params[:owner_nomination]['ContactTitle'].blank? ? 'blank' : params[:owner_nomination]['ContactTitle']) + "\n\n"
    message += "Contact Email:\n" + (params[:owner_nomination]['ContactEmail'].blank? ? 'blank' : params[:owner_nomination]['ContactEmail']) + "\n\n"
    message += "Contact Address:\n" + (params[:owner_nomination]['ContactAddress'].blank? ? 'blank' : params[:owner_nomination]['ContactAddress']) + "\n\n"

    message += "Form URL:\n" + "http://#{request.host}:#{request.port.to_s + request.fullpath}" + "\n\n"

    send_mail(to, 'hrwa-developers@libraries.cul.columbia.edu', 'HRWA Owner Nomination Form', message)
  end

  def send_mail_public_nomination(to)
    # From request:
    #request.env['HTTP_USER_AGENT']

    message = ''

    message += "Name of website/organization:\n" + (params[:public_nomination]['SiteName'].blank? ? 'blank' : params[:public_nomination]['SiteName']) + "\n\n"
    message += "URL of website:\n" + (params[:public_nomination]['URL'].blank? ? 'blank' : params[:public_nomination]['URL']) + "\n\n"
    message += "Description of website/organization:\n" + (params[:public_nomination]['Description'].blank? ? 'blank' : params[:public_nomination]['Description']) + "\n\n"
    message += "Additional Information:\n" + (params[:public_nomination]['AdditionalInformation'].blank? ? 'blank' : params[:public_nomination]['AdditionalInformation']) + "\n\n"
    message += "Permissions:\n" + (params[:public_nomination]['Permissions'].blank? ? 'blank' : params[:public_nomination]['Permissions']) + "\n\n"

    message += "Contact Name:\n" + (params[:public_nomination]['ContactName'].blank? ? 'blank' : params[:public_nomination]['ContactName']) + "\n\n"
    message += "Contact Email:\n" + (params[:public_nomination]['ContactEmail'].blank? ? 'blank' : params[:public_nomination]['ContactEmail']) + "\n\n"

    message += "Form URL:\n" + "http://#{request.host}:#{request.port.to_s + request.fullpath}" + "\n\n"

    send_mail(to, 'hrwa-developers@libraries.cul.columbia.edu', 'HRWA Public Nomination Form', message)
  end

end
