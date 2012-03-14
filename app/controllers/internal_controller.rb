require 'blacklight/catalog'
require 'pp'

class InternalController < ApplicationController
  HRWA_JIRA_EMAIL_ADDRESS = 'hrwa_portal@libraries.cul.columbia.edu'
  CC_EMAIL_ADDRESS        = 'da217@columbia.edu'
  FEEDBACK_FORM_URL       = '/internal_feedback'
  SEPARATOR = '=========================================================='    
  
  def feedback
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
      if params[ jira_param ]
        # Okay, move along
      else
        @submission_response << "This is not a valid feedback submission.  Please use the feedback form:</br>\n"
        @submission_response << %Q{<a href="#{ FEEDBACK_FORM_URL }">#{ FEEDBACK_FORM_URL }"</a><br/>}
        exit
      end
    }
    
    # Get the text for the JIRA email
    jira_email_content = get_jira_email_content( jira_params )
    
    # Construct header
    email_header[ 'to' ]      = HRWA_JIRA_EMAIL_ADDRESS
    email_header[ 'cc' ]      = CC_EMAIL_ADDRESS
    email_header[ 'subject' ] = "BUG: #{ params [ :summary ] }"
    # Send the email
    email_sent_successfully = send_jira_email( jira_email_content,
                                               email_header )    
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
  
  def get_environment_message
    environment_mssage = ''
    environment_message << "USER AGENT          : #{ params[ 'userAgent'     ] }\n"
    environment_message << "PLATFORM            : #{ params[ 'platform'      ] }\n"
    environment_message << "OPERATING SYSTEM    : #{ params[ 'oscpu'         ] }\n"
    environment_message << "JAVA ENABLED        : #{ params[ 'javaEnabled'   ] }\n"
    environment_message << "COOKIES ENABLED     : #{ params[ 'cookieEnabled' ] }\n"
    environment_message << "PLUGINS INSTALLED   : \n"
    environment_message << SEPARATOR + "\n"
    environment_message << "#{ params[ :plugins ] }\n"
    environment_message << SEPARATOR + "\n\n\n"
    environment_message << "MIMETYPES SUPPORTED : \n"
    environment_message << SEPARATOR + "\n"
    environment_message << "params[ 'mimeTypes' ] }\n"
    environment_message << SEPARATOR + "\n"
    
    # These are not that important.  Might not even need to send them.
    environment_message << "BROWSER CODE NAME             : #{ params[ 'appCodeName' ] }\n"
    environment_message << "BROWSER NAME                  : #{ params[ 'appName'     ] }\n"
    environment_message << "BROWSER VERSION               : #{ params[ 'appVersion'  ] }\n"
    environment_message << "BROWSER BUILD ID              : #{ params[ 'buildID'     ] }\n"
    environment_message << "DEFAULT LANGUAGE OF BROWSER   : #{ params[ 'language'    ] }\n"
    environment_message << "BROWSER PRODUCT NAME          : #{ params[ 'product'     ] }\n"
    environment_message << "BROWSER BUILD NUMBER          : #{ params[ 'productSub'  ] }\n"
    environment_message << "BROWSER VENDOR                : #{ params[ 'vendor'      ] }\n"
    environment_message << "BROWSER VENDOR VERSION NUMBER : #{ params[ 'vendorSub'   ] }\n"

    return environment_message
  end
  
  def get_labels_message( )
    # TODO
  end
  
  def get_jira_directive( name, value )    
    return "@name=value\n"
  end
  
  def get_jira_email_content( jira_fields )
    jira_email_content  = ''
          
    jira_email_content << get_jira_directive( 'summary'     , params[ 'summary'    ]      )
    jira_email_content << get_jira_directive( 'environment' , get_environment_message( )  )
    jira_email_content << get_jira_directive( 'issueType'   , params[ 'issueType'  ]      )
    jira_email_content << get_jira_directive( 'priority'    , params[ 'priority'   ]      )
    jira_email_content << get_jira_directive( 'components'  , params[ 'components' ]      )
    jira_email_content << get_jira_directive( 'assignee'    , params[ 'assignee'   ]      )
    jira_email_content << get_jira_directive( 'reporter'    , params[ 'reporter'   ]      )
    
    jira_email_content << "\n\n#{ params[ 'description' ] }\n"
    
    # TODO
    #jira_email_content << get_jira_directive( 'labels'     , get_labels_message( )      )
    
    return jira_email_content
  end

  def send_jira_email( email_content, email_header )
    email_sent_successfully = mail( email_header[ 'to' ],
                                    email_header[ 'subject' ],
                                    email_content,
                                    'cc: ' . email_header[ 'cc' ] )
    return email_sent_successfully        
  end
end
