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

		if(params[:new_primary_solr_server])

			new_primary_solr_server = params[:new_primary_solr_server]
			Rails.logger.debug('-----------------------------------------------------------------------------------------------------------------------------------------------')
			debugger

			@solr_yaml = YAML.load_file( 'config/solr.yml' )

			@solr_yaml[ Rails.env ][ 'asf' ][ 'url' ] = @solr_yaml['valid_overrides'][new_primary_solr_server]['asf']
			@solr_yaml[ Rails.env ][ 'fsf' ][ 'url' ] = @solr_yaml['valid_overrides'][new_primary_solr_server]['fsf']
			@solr_yaml[ Rails.env ][ 'site_detail' ][ 'url' ] = @solr_yaml['valid_overrides'][new_primary_solr_server]['site_detail']

			File.open("tmp/solr.yml", "w") { |f| f.write(@solr_yaml.to_yaml) }

			#If the write was successful, replace the real yml file with the new one
			#File.open("#{RAILS_ROOT}/config/application.yml", 'w') { |f| YAML.dump(a_config, f) }
			flash[:notice] = 'Your primary solr server is now set to <strong>'.html_safe + params[:new_primary_solr_server].html_safe + '</strong>.'.html_safe;
		end

		@solr_yaml = YAML.load_file( 'config/solr.yml' )

  end

end
