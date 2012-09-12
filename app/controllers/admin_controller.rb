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

  # Hrwa Note: No need to clear the solr indexes, so I'm commenting this out for now.
  #def clear_solr_index()
  #  solrTaskHandler = Hrwa::Admin::SolrTaskHandler.new(YAML.load_file('config/solr.yml')[Rails.env]['url'])
  #  result = solrTaskHandler.clear_solr_index
  #
  #  if (result)
  #    flash[:notice] = 'Your solr index has been cleared.'
  #  else
  #    flash[:error] = "An error occurred and your solr index could not be cleared. Please check your log output for details."
  #  end
  #
  #  redirect_to admin_path
  #end

  def reindex_solr_from_xml_file()

    solrTaskHandler = Hrwa::Admin::SolrTaskHandler.new(YAML.load_file('config/solr.yml')[Rails.env]['url'])

    result = solrTaskHandler.reindex_solr_from_xml_file('extras/lindquist.xml')

    if(result)
      flash[:notice] = 'Your solr index has been reindexed.'
    else
      flash[:notice] = 'An error occurred while attempting to reindex. Please check your log output for details.'
    end

    redirect_to admin_path

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
