class HRWA::Admin::SolrConfigRewriter
	unloadable

	# Rewrites the solr.yml file, replacing the current environment's set solr
	# servers with the selected new_primary_solr_server
	# Returns true on success, false on failure.
	def change_primary_solr_server_in_solr_config(new_primary_solr_server, current_environment = Rails.env)

		@original_yaml_string = IO.read('config/solr.yml');

		amp_regex = /:\s*&.+$/
		asterisk_regex = /:\s*\*.+$/

		# Get a list of all original &'s
		all_amps = @original_yaml_string.scan(amp_regex)
		# Get a list of all original *'s
		all_asterisks = @original_yaml_string.scan(asterisk_regex)

		# If the number of ampersands does not match the number of asterisks, that's bad.  Return an error:
		if all_amps.length != all_asterisks.length
			return 'There is an alias count mismatch in your solr.yml file. The number of &s doesn\'t match the number of *s.'
		end

		@solr_yaml = YAML.load_file( 'config/solr.yml' )

		@solr_yaml[ current_environment ][ 'asf' ][ 'url' ] = @solr_yaml['valid_overrides'][new_primary_solr_server]['asf']['url']
		@solr_yaml[ current_environment ][ 'fsf' ][ 'url' ] = @solr_yaml['valid_overrides'][new_primary_solr_server]['fsf']['url']
		@solr_yaml[ current_environment ][ 'site_detail' ][ 'url' ] = @solr_yaml['valid_overrides'][new_primary_solr_server]['site_detail']['url']

		new_yaml_string = @solr_yaml.to_yaml

		Rails.logger.debug('------------------------------- AMP MATCHES ' + all_amps.to_s + ' -------------------------------')

		# Re-add all original &'s
		new_yaml_string.scan(amp_regex).each do |match|
			Rails.logger.debug('------------------------------- REPLACED SOMETHING! ' + match + ' -------------------------------')
			new_yaml_string = new_yaml_string.sub(match, all_amps.shift)
		end

		# Re-add all original *'s
		new_yaml_string.scan(asterisk_regex) do |match|
			Rails.logger.debug('------------------------------- REPLACED SOMETHING! ' + match + ' -------------------------------')
			new_yaml_string = new_yaml_string.sub(match, all_asterisks.shift)
		end

		Rails.logger.debug('------------------------------- New yaml: ' + new_yaml_string.to_s + ' -------------------------------')

		File.open("tmp/solr.yml", "w") { |f| f.write(new_yaml_string) }

		#If the write was successful, replace the real yml file with the new one
		#File.open("#{RAILS_ROOT}/config/application.yml", 'w') { |f| YAML.dump(a_config, f) }

		success = true

		return success
	end

end
