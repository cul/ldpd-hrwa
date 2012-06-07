require 'spec_helper'

class MockRequest
  attr_accessor :remote_ip
end

class MockStaticController
  include HRWA::Static
  
  attr_accessor :request
end

describe 'HRWA::Static' do 
  before :all do
    @ip = '111.111.111.111'
    @mock_static_controller         = MockStaticController.new
    @mock_static_controller.request = MockRequest.new
    @mock_static_controller.request.remote_ip = @ip
  end

  it '#send_public_feedback sends email correctly' do
    feedback_text = 'This is a text.'
    contact_name  = 'The Public'
    contact_email = 'ThePublic@public.com'
    params = { :feedback =>
      { 
        'Feedback Text'   => feedback_text,
        'Contact Name'    => contact_name,
        'Contact Email'   => contact_email,
      }
    }
    recipient = 'culhrweb-all@libraries.cul.columbia.edu'
    subject   = 'HRWA Public Feedback'
    
    @mock_static_controller.send_public_feedback( recipient, params )
    
    public_feedback_email                   =  ActionMailer::Base.deliveries.last
    public_feedback_email.to.first.should   == recipient
    public_feedback_email.from.first.should == recipient
    public_feedback_email.subject.should    == subject
    
    # Can't match the whole body because we don't know the timestamp
    # No timestamp test for now because the method being tested timestamps
    # very precisely.  Tricky to match that.
    public_feedback_email.body.should       match( "Feedback Text: #{ feedback_text }"   )
    public_feedback_email.body.should       match( "Contact Name: #{ contact_name }"  )
    public_feedback_email.body.should       match( "Contact Email: #{ contact_email}" )
    public_feedback_email.body.should       match( "IP Address: #{ @ip }"              )
  end
  
  it '#send_bug_report sends email correctly' do
    bug_text      = 'This is a bug.'
    contact_name  = 'The Bug Reporter'
    contact_email = 'TheBugReporter@bugreporter.com'
    params = { :bugReport =>
      { 
        'Bug Report Text' => bug_text,
        'Contact Name'    => contact_name,
        'Contact Email'   => contact_email,
      }
    }
    recipient = 'culhrweb-bugreports@libraries.cul.columbia.edu'
    subject   = 'HRWA Public Bug Report'
    
    @mock_static_controller.send_bug_report( recipient, params )
    
    public_feedback_email                   =  ActionMailer::Base.deliveries.last
    public_feedback_email.to.first.should   == recipient
    public_feedback_email.from.first.should == recipient
    public_feedback_email.subject.should    == subject
    
    # Can't match the whole body because we don't know the timestamp
    # No timestamp test for now because the method being tested timestamps
    # very precisely.  Tricky to match that.
    public_feedback_email.body.should       match( "Bug Report Text: #{ bug_text }"   )
    public_feedback_email.body.should       match( "Contact Name: #{ contact_name }"  )
    public_feedback_email.body.should       match( "Contact Email: #{ contact_email}" )
    public_feedback_email.body.should       match( "IP Address: #{ @ip }"              )
  end
end

