require 'hrwa/update/source_hard_coded_files.rb'
require 'hrwa/configurator.rb'
require 'hrwa/archive_search_configurator.rb'
require 'hrwa/find_site_search_configurator.rb'
require 'hrwa/site_detail_configurator.rb'

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

		@solr_yaml = YAML.load_file('config/solr.yml')

		if(params[:reset_primary_solr_server])
			# The line below makes sure that only servers in the valid overrides section of solr.yml can be selected
			HRWA::Configurator.reset_solr_config
			flash[:notice] = 'Your solr servers have been reset to their factory settings.'.html_safe;
		end

		if(params[:new_primary_solr_server])
			# The line below makes sure that only servers in the valid overrides section of solr.yml can be selected
			HRWA::Configurator.override_solr_url(@solr_yaml['valid_overrides'][params[:new_primary_solr_server]])
			flash[:notice] = 'Your solr server settings have been changed.'.html_safe;
		end

		archive_solr_url = HRWA::ArchiveSearchConfigurator.solr_url
		find_site_solr_url = HRWA::FindSiteSearchConfigurator.solr_url
		site_detail_solr_url = HRWA::SiteDetailConfigurator.solr_url

		@solr_urls = 	{
										:archive			=> archive_solr_url,
										:find_site		=> find_site_solr_url,
										:site_detail	=> site_detail_solr_url,
									}



  end

end
