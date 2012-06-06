module HRWA::Static
  unloadable
  
  def send_public_feedback( recipient = 'culhrweb-all@libraries.cul.columbia.edu', params = params )
    subject = 'HRWA Public Feedback' 
    send_helper( params[ :feedback ], recipient, subject )
  end
  
  def send_bug_report( recipient = 'culhrweb-bugreports@libraries.cul.columbia.edu', params = params )
    subject = 'HRWA Public Feedback' 
    send_helper( params[ :bugReport ], recipient, subject )
  end
  
  def send_helper( param, recipient, subject )
    current_time = Time.new
    param['Timestamp'] = current_time.to_time.to_s + ' (' + current_time.to_time.to_i.to_s + ')';
    param['IP Address'] = request.remote_ip;

    email_body = '';

    param.each_pair { |key, value|
      email_body += "#{key}: #{value}\n\n"
    }

    email_body += 'If the IP address above is associated with periodic feedback form spam, please ask the developers about blocking it.'

    Mailer.send_mail( recipient, recipient, subject, email_body).deliver
  end
end