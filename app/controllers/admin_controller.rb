require 'hrwa/update/source_hard_coded_files.rb'

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
		@solr_yaml = YAML.load_file( 'config/solr.yml' )

		if(params[:new_primary_solr_server])


			#If successful, replace the real yml file with the new one
			#File.open("#{RAILS_ROOT}/config/application.yml", 'w') { |f| YAML.dump(a_config, f) }
			flash[:notice] = 'Your primary solr server is now set to: ' + params[:new_primary_solr_server];
		end


  end

end
