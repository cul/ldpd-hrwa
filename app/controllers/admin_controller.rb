require 'hrwa/update/source_hard_coded_files.rb'
require 'hrwa/admin/solr_config_rewriter.rb'

# This controller handles administrative stuff
class AdminController < ApplicationController

  before_filter :authenticate_admin!

	# Note: There is no view associated with refresh_browse_and_option_lists
	# We do a redirect at the end of this actions
  def refresh_browse_and_option_lists

		sourceHardCodedFilesUpdater = HRWA::Update::SourceHardCodedFiles.new(
		  'app/helpers/hrwa/collection_browse_lists_source_hardcoded.rb',
		  'app/helpers/hrwa/filter_options_source_hardcoded.rb',
		  'http://carter.cul.columbia.edu:8080/solr-4/fsf',
	  )

	begin
		sourceHardCodedFilesUpdater.update_rails_file( :browse_lists  )
		sourceHardCodedFilesUpdater.update_rails_file( :filter_options )

		flash[:notice] = 'The browse_lists and filter_options files have been updated.'

		rescue UpdateException => e
			flash[:error] = "Update of collection browse and advanced filter options aborted with error: #{ e }"
		end

		redirect_to admin_path
  end

  def index
YAML::ENGINE.yamler = 'psych'
		if(params[:new_primary_solr_server])
			solrConfigRewriter = HRWA::Admin::SolrConfigRewriter.new
			if solrConfigRewriter.change_primary_solr_server_in_solr_config(params[:new_primary_solr_server])
				flash[:notice] = 'Your primary solr server is now set to <strong>'.html_safe + params[:new_primary_solr_server] + '</strong>.'.html_safe;
			else
				flash[:error] = 'An error occurred. The solr.yml file has not been modified.';
			end
		end

		@solr_yaml = YAML.load_file( 'config/solr.yml' )

  end

end
