# -*- encoding : utf-8 -*-
require 'spec_helper'

Capybara.javascript_driver = :webkit
#Capybara.default_wait_time = 30

admin_login_username = 'admin'
admin_login_password = 'supercomplexpassword'

describe 'the admin control panel' do

  before :each do
    ServiceUser.new({:email => "test-admin-user@columbia.edu", :username => admin_login_username, :password => "supercomplexpassword", :password_confirmation => "supercomplexpassword" }).save!
  end

  after :each do
    @deleted_user = ServiceUser.find_for_authentication(:username => admin_login_username)
    @deleted_user.destroy
  end

  it 'is possible to log into the admin control panel' do
    visit '/service_users/sign_in'
    fill_in 'service_user_username', :with => admin_login_username
    fill_in 'service_user_password', :with => admin_login_password
    click_button 'Sign in'
    visit '/admin'

    page.should have_content( 'Admin Control Panel' )

    #Cleanup - Log out

    click_link 'Sign Out'
  end

  describe 'Solr server overriding' do

    before :each do
      visit '/service_users/sign_in'
      fill_in 'service_user_username', :with => admin_login_username
      fill_in 'service_user_password', :with => admin_login_password
      click_button 'Sign in'
      visit '/admin'
    end

    after :each do
      #Cleanup - Log out
      click_link 'Sign Out'
    end

    it 'is possible to override the solr servers, and also possible to reset them to their defaults' do
      page.find('select[name="solr_server_name"]').select('fillmore')
      click_button( 'Override' )

      page.should have_content( 'asf: http://fillmore.cul.columbia.edu:8080/solr-4.2/hrwa-asf' )
      page.should have_content( 'fsf: http://fillmore.cul.columbia.edu:8080/solr-4.2/hrwa-fsf' )
      page.should have_content( 'site_detail: http://fillmore.cul.columbia.edu:8080/solr-4.2/hrwa-fsf' )

      # Fresh visit, not just checking after form submission
      visit '/admin'

      page.should have_content( 'asf: http://fillmore.cul.columbia.edu:8080/solr-4.2/hrwa-asf' )
      page.should have_content( 'fsf: http://fillmore.cul.columbia.edu:8080/solr-4.2/hrwa-fsf' )
      page.should have_content( 'site_detail: http://fillmore.cul.columbia.edu:8080/solr-4.2/hrwa-fsf' )

      click_button( 'Reset to Defaults' )

      # Fresh visit, not just checking after form submission
      visit '/admin'

      page.should have_content( 'asf: http://spatha.cul.columbia.edu:8081/solr-4.2-hrwa/hrwa-asf' )
      page.should have_content( 'fsf: http://spatha.cul.columbia.edu:8081/solr-4.2-hrwa/hrwa-fsf' )
      page.should have_content( 'site_detail: http://spatha.cul.columbia.edu:8081/solr-4.2-hrwa/hrwa-fsf' )

    end

  end

end
