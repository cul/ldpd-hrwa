# -*- encoding : utf-8 -*-
require 'spec_helper'

Capybara.javascript_driver = :webkit
#Capybara.default_wait_time = 30

admin_login_username = 'admin'
admin_login_password = 'supercomplexpassword'

describe 'the admin control panel' do

  it 'brings up a sign in screen when you click the top menu "Admin Login" link' do
    visit '/'
    click_link 'Menu'
    click_link 'Admin Login'
    page.should have_content( 'Sign in' )
  end

  it 'is possible to log into the admin control panel' do
    visit '/admin'
    fill_in 'admin_username', :with => admin_login_username
    fill_in 'admin_password', :with => admin_login_password
    click_button 'Sign in'
    visit '/admin'

    page.should have_content( 'Admin Control Panel' )

    #Cleanup - Log out

    click_link 'Menu'
    click_link 'Log out'
  end

  describe 'Solr server overriding' do

    before :each do
      visit '/admin'
      fill_in 'admin_username', :with => admin_login_username
      fill_in 'admin_password', :with => admin_login_password
      click_button 'Sign in'
      visit '/admin'
    end

    after :each do
      #Cleanup - Log out
      click_link 'Menu'
      click_link 'Log out'
    end

    it 'should have carter set as the default solr server for the test environment' do
      page.should have_content( 'Archive primary Solr server: carter' )
      page.should have_content( 'Find Site primary Solr server: carter' )
      page.should have_content( 'Site Detail primary Solr server: carter' )
    end

    it 'is possible to override the solr servers, and also possible to reset them to their defaults' do
      page.find('#new_primary_solr_server').select('coolidge')
      click_button( 'Go' )

      page.should have_content( 'Archive primary Solr server: coolidge' )
      page.should have_content( 'Find Site primary Solr server: coolidge' )
      page.should have_content( 'Site Detail primary Solr server: coolidge' )

      # Fresh visit, not just checking after form submission
      visit '/admin'

      page.should have_content( 'Archive primary Solr server: coolidge' )
      page.should have_content( 'Find Site primary Solr server: coolidge' )
      page.should have_content( 'Site Detail primary Solr server: coolidge' )

      click_button( 'Reset all primary solr servers to defaults' )

      # Fresh visit, not just checking after form submission
      visit '/admin'

      page.should have_content( 'Archive primary Solr server: carter' )
      page.should have_content( 'Find Site primary Solr server: carter' )
      page.should have_content( 'Site Detail primary Solr server: carter' )
    end

    it 'passes a test!' do
      #true
    end

  end

end
