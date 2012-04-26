class HRWA::Admin::SolrConfigRewriter
	unloadable

	# Rewrites the solr.yml file, replacing the current environment's set solr
	# servers with the selected new_primary_solr_server
	# Returns true on success, false on failure.
	def change_primary_solr_server_in_solr_config(new_primary_solr_server_name, current_environment = Rails.env)

		@valid_overrides = YAML.load_file( 'config/solr.yml' )['valid_overrides']

		if(@valid_overrides.includes?(new_primary_solr_server_name))
			new_primary_server_url = @valid_overrides[new_primary_solr_server_name]
			HRWA:ArchiveSearchConfigurator.new_primary_server_url(new_primary_server_url)
			HRWA:FindSiteSearchConfigurator.new_primary_server_url(new_primary_server_url)
			HRWA:SiteDetailConfigurator.new_primary_server_url(new_primary_server_url)
		end

	end

end
