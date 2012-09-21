require 'hrwa/admin/solr_task_handler.rb'

# This controller handles administrative stuff
class AdminController < ApplicationController

  include Hrwa::MailHelper

  before_filter :do_authentication_check, :_check_for_allowed_users, :except => :login_options

  # THe do_authentication_check method below takes the place of devise's authenticate_service_user! and authenticate_user! methods.
  def do_authentication_check
    if !user_signed_in? && !service_user_signed_in?
      redirect_to :action => 'login_options'
    end
  end

  def login_options

  end

  def _check_for_allowed_users

    if service_user_signed_in?
      # That's fine
    elsif user_signed_in?
      # Need to check to see if this user is allowed to do anything
      allowed_users = ['elo2112', 'er2576', 'ba2213']
      if( ! allowed_users.include?(current_user.login) )
        # If not on the allowed list, then log this user out

        puts 'LOGGIN U OUTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT'

        redirect_to destroy_user_session_path
      end
    end

  end

  def index
  end

  # This method updates the hardcoded browse list files using live data from the Solr index
  def update_hardcoded_browse_lists()
    solrTaskHandler = Hrwa::Admin::SolrTaskHandler.new
    result = solrTaskHandler.update_hardcoded_browse_lists

    if (result)
      flash[:notice] = 'Your browse lists have been updated.'
    else
      flash[:error] = "An error occurred and your browse lists could not be updated. Please check your log output for details."
    end

    redirect_to admin_path
  end

end
