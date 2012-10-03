require 'blacklight/catalog'
require 'mail'
require 'pp'

class InternalController < ApplicationController

  include Hrwa::Internal

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

end
