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
    params = { :feedback =>
      { 
        'Feedback Text'   => 'This is a test.',
        'Contact Name'    => 'The Public',
        'Contact Email'   => 'ThePublic@public.com',
      }
    }
    recipient = 'culhrweb-all@libraries.cul.columbia.edu'
    subject   = 'HRWA Public Feedback'
    
    # Make a copy to verify results later.  params will have new pairs inserted into it
    # by the method being tested
    params_check = Marshal.load( Marshal.dump( params ) )
    
    @mock_static_controller.send_public_feedback( recipient, params )
    
    email = ActionMailer::Base.deliveries.last        
    verify_email( email, recipient, subject, params_check[ :feedback ], @ip )
  end
  
  it '#send_bug_report sends email correctly' do
    params = { :bugReport =>
      { 
        'Bug Report Text' => 'This is a bug.',
        'Contact Name'    => 'The Bug Reporter',
        'Contact Email'   => 'TheBugReporter@bugreporter.com',
      }
    }
    
    # Make a copy to verify results later.  params will have new pairs inserted into it
    # by the method being tested
    params_check = Marshal.load( Marshal.dump( params ) )
    
    recipient = 'culhrweb-bugreports@libraries.cul.columbia.edux'
    subject   = 'HRWA Public Bug Report'
    
    @mock_static_controller.send_bug_report( recipient, params )
    
    email = ActionMailer::Base.deliveries.last        
    verify_email( email, recipient, subject, params_check[ :bugReport ], @ip )
  end
end

def verify_email( email, recipient, subject, params, ip )
    email.to.first.should   == recipient
    email.from.first.should == recipient
    email.subject.should    == subject
    
    # Can't match the whole body because we don't know the timestamp
    # No timestamp test for now because the method being tested timestamps
    # very precisely.  Tricky to match that.
    params.each_pair { | key, value |
      email.body.should match( "#{ key }: #{ value }" )
    }
    email.body.should match( "IP Address: #{ ip }" )
end
