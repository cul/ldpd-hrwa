# -*- encoding : utf-8 -*-

# This controller handles all requests static HTML pages
class ApiController < ApplicationController

	def index
	end

  def sites

		supported_fields = {
			'organization_based_in' => 'organization_based_in__facet',
			'geographic_focus' => 'geographic_focus__facet'
		}

		fields = params[:fields].split(',').collect{|x| x.strip} if ! params[:fields].blank?
		fields ||= []
		# Remove any fields that are not in supported_fields
		fields.delete_if{ |field| ! supported_fields.include?(field) }

		@solr_url = YAML.load_file('config/solr.yml')[Rails.env]['fsf']['url']
		@rsolr = RSolr.connect :url => @solr_url

    @response = @rsolr.get 'select',
														:params => {
															:q  => '*:*',
															:qt => 'search',
															:facet => true,
															:'facet.sort' => 'index', # We want Solr to order facets based on their index (alphabetically, numerically, etc.)
															:'facet.field' => ['original_urls',
																								 'subject__facet',
																								 'geographic_focus__facet',
																								 'language__facet',

																								 'creator_name__facet',
																								 'organization_based_in__facet',
																								 'organization_type__facet',
																								 ],

															:'f.original_urls.facet.limit' => -1,
															:'f.subject__facet.facet.limit' => -1,
															:'f.geographic_focus__facet.facet.limit' => -1,
															:'f.language__facet.facet.limit' => -1,

															:'f.creator_name__facet.facet.limit' => -1,
															:'f.organization_based_in__facet.facet.limit' => -1,
															:'f.organization_type__facet.facet.limit' => -1,

															# Row Count Note: http://wiki.apache.org/solr/CommonQueryParameters
															# "The default value is "10", which is used if the parameter is not specified.
															# If you want to tell Solr to return all possible results from the query without
															# an upper bound, specify rows to be 10000000 or some other ridiculously large
															# value that is higher than the possible number of rows that are expected."
															:rows => 999999999

														}

		# Generate field counts
		field_counts = {}
		fields.each {|field|

			field_counts_for_field = {}

			@response['facet_counts']['facet_fields'][supported_fields[field]].each_slice(2) {|group_of_two_elements| field_counts_for_field[group_of_two_elements[0]] = group_of_two_elements[1] }

			field_counts[field] = field_counts_for_field
		}

		site_count = @response['response']['docs'].length

		sites = {}

		@response['response']['docs'].each {|doc|

			site_data = {}

			fields.each {|field|
				site_data[field] = doc[supported_fields[field]]
			}

			sites[doc['bib_key']] = site_data
		}

		@data = {
			'site_count' => site_count,
			'sites' => sites,
			'field_counts' => field_counts
		}

		respond_to do |format|
			format.json { }
		end

	end

end
