class Mailer < ActionMailer::Base

  def send_mail(m_to, m_from, m_subject, m_body)
    @email_body = m_body

    mail(:to => m_to, :subject => m_subject, :from => m_from)
  end

end
