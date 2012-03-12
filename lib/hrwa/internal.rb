require 'net/smtp'

module HRWA::Internal
  # HRWA_JIRA_EMAIL_ADDRESS = 'hrwa_portal@libraries.cul.columbia.edu'
  HRWA_JIRA_EMAIL_ADDRESS = 'da217@columbia.edu'
  CC_EMAIL_ADDRESS        = 'da217@columbia.edu'
  FEEDBACK_FORM_URL       = '/internal_feedback'
  SEPARATOR               =
    '=========================================================='    
  
  def feedback_submit( user_params = params )
    debugger
    @submission_response = ''
    jira_params = [
                   'appCodeName',
                   'appName',
                   'appVersion',
                   'assignee',
                   'buildID',
                   'components',
                   'cookieEnabled',
                   'description',
                   'issueType',
                   'javaEnabled',
                   'language',
                   'mimeTypes',
                   'oscpu',
                   'platform',
                   'plugins',
                   'priority',
                   'product',
                   'productSub',
                   'reporter',
                   'submit',
                   'summary',
                   'timestamp',
                   'userAgent',
                   'vendor',
                   'vendorSub',
                  ]

    # Validate this request.  All fields are required because the form should not
    # have been submitted without them.
    jira_params.each { | jira_param |    
      if user_params[ jira_param ]
        # Okay, move along
      else
        @submission_response << "This is not a valid feedback submission.  Please use the feedback form:</br>\n"
        @submission_response << %Q{<a href="#{ FEEDBACK_FORM_URL }">#{ FEEDBACK_FORM_URL }"</a><br/>" }
        render and return
      end
    }
    
    # Get the text for the JIRA email
    jira_email_content = jira_email_content( user_params )
    
    # Construct header
    email_header[ 'to' ]      = HRWA_JIRA_EMAIL_ADDRESS
    email_header[ 'cc' ]      = CC_EMAIL_ADDRESS
    email_header[ 'subject' ] = "BUG: #{ user_params [ :summary ] }"
    # Send the email
    email_sent_successfully = send_jira_email( email_header, jira_email_content )    
    # Report to user
    if email_sent_successfully
      @submission_response << "Feedback has been successfully sent to Jira Project HRWA Portal.\nInfo submitted:\n"
      @submission_response << "<pre>#{ jira_email_content }</pre>"
    else
      @submission_response << 'Unable to submit feedback to Jira Project HRWA Portal.  ' <<
        'Please report this problem to da217@columbia.edu.'
      exit
    end
  end
  
  def environment_message( user_params = params )
    environment_mssage = ''
    environment_message << "USER AGENT          : #{ user_params[ :userAgent     ] }\n"
    environment_message << "PLATFORM            : #{ user_params[ :platform      ] }\n"
    environment_message << "OPERATING SYSTEM    : #{ user_params[ :oscpu         ] }\n"
    environment_message << "JAVA ENABLED        : #{ user_params[ :javaEnabled   ] }\n"
    environment_message << "COOKIES ENABLED     : #{ user_params[ :cookieEnabled ] }\n"
    environment_message << "PLUGINS INSTALLED   : \n"
    environment_message << SEPARATOR + "\n"
    environment_message << "#{ user_params[ :plugins ] }\n"
    environment_message << SEPARATOR + "\n\n\n"
    environment_message << "MIMETYPES SUPPORTED : \n"
    environment_message << SEPARATOR + "\n"
    environment_message << "user_params[ :mimeTypes' ] }\n"
    environment_message << SEPARATOR + "\n"
    
    # These are not that important.  Might not even need to send them.
    environment_message << "BROWSER CODE NAME             : #{ user_params[ :appCodeName ] }\n"
    environment_message << "BROWSER NAME                  : #{ user_params[ :appName     ] }\n"
    environment_message << "BROWSER VERSION               : #{ user_params[ :appVersion  ] }\n"
    environment_message << "BROWSER BUILD ID              : #{ user_params[ :buildID     ] }\n"
    environment_message << "DEFAULT LANGUAGE OF BROWSER   : #{ user_params[ :language    ] }\n"
    environment_message << "BROWSER PRODUCT NAME          : #{ user_params[ :product     ] }\n"
    environment_message << "BROWSER BUILD NUMBER          : #{ user_params[ :productSub  ] }\n"
    environment_message << "BROWSER VENDOR                : #{ user_params[ :vendor      ] }\n"
    environment_message << "BROWSER VENDOR VERSION NUMBER : #{ user_params[ :vendorSub   ] }\n"

    return environment_message
  end
  
  def labels_message( )
    # TODO
  end
  
  def jira_directive( name, value )    
    return "@name=value\n"
  end
  
  def jira_email_content( user_params = params)
    jira_email_content  = ''
          
    jira_email_content << jira_directive( 'summary'     , user_params[ :summary    ]      )
    jira_email_content << jira_directive( 'environment' , environment_message( user_params )      )
    jira_email_content << jira_directive( 'issueType'   , user_params[ :issueType  ]      )
    jira_email_content << jira_directive( 'priority'    , user_params[ :priority   ]      )
    jira_email_content << jira_directive( 'components'  , user_params[ :components ]      )
    jira_email_content << jira_directive( 'assignee'    , user_params[ :assignee   ]      )
    jira_email_content << jira_directive( 'reporter'    , user_params[ :reporter   ]      )
    
    jira_email_content << "\n\n#{ user_params[ :description ] }\n"
    
    # TODO
    #jira_email_content << get_jira_directive( 'labels'     , get_labels_message( )      )
    
    return jira_email_content
  end

  def send_jira_email( email_header, email_content )
    message_string = <<END_OF_MESSAGE
From:

To: #{ email_header[ :to ] }

Cc: #{ email_header[ :cc ] }

Subject: #{ email_header[ :subject ] }

#{ email_content }    
END_OF_MESSAGE

    Net::SMTP.start('', 25) { |smtp|
      email_sent_successfully smtp.send_message( message_string,
                                                 '',
                                                 [ email_header[ :to   ],
                                                   email_header[ :cc   ] ] )
    }

    return email_sent_successfully
  end
  
end