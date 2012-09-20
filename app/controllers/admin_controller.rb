require 'hrwa/admin/solr_task_handler.rb'

# This controller handles administrative stuff
class AdminController < ApplicationController

  include Hrwa::MailHelper

  before_filter :authenticate_user!, :check_for_allowed_users

  def check_for_allowed_users

    allowed_users = ['elo2112', 'er2576', 'ba2213']

    if( ! allowed_users.include?(current_user.login) )
      # Then log this user out
      redirect_to destroy_user_session_path
    end
  end

  def index()

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
