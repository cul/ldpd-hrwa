require 'blacklight/catalog'
require 'mail'
require 'pp'

class InternalController < ApplicationController

  HRWA_JIRA_EMAIL_ADDRESS = 'hrwa_portal@libraries.cul.columbia.edu'
  CC_EMAIL_ADDRESS        = 'da217@columbia.edu'
  FEEDBACK_FORM_URL       = '/internal_feedback'
  SEPARATOR = '=========================================================='    
  
  def feedback_form
    render 'feedback_form', :layout => false
  end
  
  def feedback_submit
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
      end
    }


    # setup JIRA soap instance
    server = JIRA::JIRAService.new APP_CONFIG["jira"]["host"]
    server.login(APP_CONFIG["jira"]["username"], APP_CONFIG["jira"]["password"])

    # create the ticket
    jira_ticket_create = send_ticket_to_jira(server, params, environment_message)
                                               
    # Report to user
    if jira_ticket_create
      @submission_status   = "Jira issue [#{jira_ticket_create.key}] created"
      @submission_response = jira_email_content
    else
      @submission_status = 'Creation of Jira issue failed'
      @submission_response << 'Unable to submit feedback to Jira Project HRWA Portal.  ' <<
        'Please report this problem to da217@columbia.edu.'
    end
  end
  
  def environment_message
    message = ''
    message << "USER AGENT          : #{ params[ 'userAgent'     ] }\n"
    message << "PLATFORM            : #{ params[ 'platform'      ] }\n"
    message << "OPERATING SYSTEM    : #{ params[ 'oscpu'         ] }\n"
    message << "JAVA ENABLED        : #{ params[ 'javaEnabled'   ] }\n"
    message << "COOKIES ENABLED     : #{ params[ 'cookieEnabled' ] }\n"
    message << "PLUGINS INSTALLED   : \n"
    message << SEPARATOR + "\n"
    message << "#{ params[ :plugins ] }\n"
    message << SEPARATOR + "\n\n\n"
    message << "MIMETYPES SUPPORTED : \n"
    message << SEPARATOR + "\n"
    message << "params[ 'mimeTypes' ] }\n"
    message << SEPARATOR + "\n"
    
    # These are not that important.  Might not even need to send them.
    message << "BROWSER CODE NAME             : #{ params[ 'appCodeName' ] }\n"
    message << "BROWSER NAME                  : #{ params[ 'appName'     ] }\n"
    message << "BROWSER VERSION               : #{ params[ 'appVersion'  ] }\n"
    message << "BROWSER BUILD ID              : #{ params[ 'buildID'     ] }\n"
    message << "DEFAULT LANGUAGE OF BROWSER   : #{ params[ 'language'    ] }\n"
    message << "BROWSER PRODUCT NAME          : #{ params[ 'product'     ] }\n"
    message << "BROWSER BUILD NUMBER          : #{ params[ 'productSub'  ] }\n"
    message << "BROWSER VENDOR                : #{ params[ 'vendor'      ] }\n"
    message << "BROWSER VENDOR VERSION NUMBER : #{ params[ 'vendorSub'   ] }\n"

    return message
  end
  
  def labels_message( )
    # TODO
  end
  
  def jira_directive( name, value )    
    return "#{ name } = #{ value }\n"
  end
  
  def jira_email_content
    content = ''
          
    content << jira_directive( 'summary'     , params[ 'summary'    ]      )
    content << jira_directive( 'environment' , environment_message         )
    content << jira_directive( 'issueType'   , params[ 'issueType'  ]      )
    content << jira_directive( 'priority'    , params[ 'priority'   ]      )
    content << jira_directive( 'components'  , params[ 'components' ]      )
    content << jira_directive( 'assignee'    , params[ 'assignee'   ]      )
    content << jira_directive( 'reporter'    , params[ 'reporter'   ]      )
    
    content << "\n\n#{ params[ 'description' ] }\n"
    
    # TODO
    # content << get_jira_directive( 'labels'     , get_labels_message( )      )
    
    return content
  end

  def send_jira_email( email_content, email_header )
    mail = Mail.new {
      from    HRWA_JIRA_EMAIL_ADDRESS
      to      email_header[ 'to'      ]
      cc      email_header[ 'cc'      ]
      subject email_header[ 'subject' ]
      body    email_content
    }
    mail.deliver!
  end

private

  # creates an issue based on the parameters supplied and pushes it to the server
  def send_ticket_to_jira(server,params,environment_message)
    found_component = server.components_for_project_with_key(APP_CONFIG["jira"]["project"]).select { |cmp| cmp.name == params['components']} # find component
    issue = JIRA::Issue.new()
    issue.type_id = params['issueType'] # set issue type
    issue.priority_id = params['priority'] # set priority
    issue.summary = params["summary"] # set summary
    issue.project_name = APP_CONFIG["jira"]["project"] # set the project
    issue.reporter_username = params['reporter'] # set reporter
    issue.assignee_username = params['assignee'] unless params['assignee'].match(/unassigned/i)  # set assignee if the parameter points to an user, otherwise don't
    issue.components = found_component if found_component # set component
    issue.description = params['description'] if !params['description'].nil? # set the description, unless it's empty
    issue.environment = environment_message # might want to fix this later to map to several custom fields rather than one, seems a bit messy
    returned_issue = server.create_issue_with_issue(issue) # create the issue on the server
  end



end
