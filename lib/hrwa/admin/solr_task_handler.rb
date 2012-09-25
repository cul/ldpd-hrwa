class Hrwa::Admin::SolrTaskHandler
	#unloadable

  def initialize

  end

  def update_hardcoded_browse_lists

		@solr_url = YAML.load_file('config/solr.yml')[Rails.env]['fsf']['url']

		puts 'Updating browse lists based on Solr core: ' + @solr_url

		@rsolr = RSolr.connect :url => @solr_url

    @response = @rsolr.get 'select',
                          :params => {
                            :q  => '*:*',
                            :qt => 'search',
                            :facet => true,
                            :'facet.sort' => 'index', # We want Solr to order facets based on their index (alphabetically, numerically, etc.)
                            :'facet.field' => ['title__facet',
                                               'original_urls',
                                               'subject__facet',
                                               'geographic_focus__facet',
                                               'language__facet',

                                               'creator_name__facet',
                                               'organization_based_in__facet',
                                               'organization_type__facet',
                                               ],

                            :'f.title__facet.facet.limit' => -1,
                            :'f.original_urls.facet.limit' => -1,
                            :'f.subject__facet.facet.limit' => -1,
                            :'f.geographic_focus__facet.facet.limit' => -1,
                            :'f.language__facet.facet.limit' => -1,

														:'f.creator_name__facet.facet.limit' => -1,
														:'f.organization_based_in__facet.facet.limit' => -1,
														:'f.organization_type__facet.facet.limit' => -1,

                            :rows => 0,
                          }

		facet_groups = Hash.new()
		last_group_name = ''
		last_item_key = ''

		@response['facet_counts']['facet_fields'].each{ | facet_type_or_group_of_facets |
			facet_type_or_group_of_facets.each{ |facet_name_or_group|
				if facet_name_or_group.is_a?(String)

					last_group_name = facet_name_or_group
					facet_groups[last_group_name] = Hash.new()

				else

					facet_name_or_group.each_with_index{ |facet_name_or_sort_field, index|

						facet_groups[last_group_name]

						if(index%2 == 0)
							last_item_key = facet_name_or_sort_field
						else
							if(facet_name_or_sort_field.is_a?(Fixnum))
								facet_groups[last_group_name][last_item_key] = facet_name_or_sort_field.to_s
							else
								facet_groups[last_group_name][last_item_key] = facet_name_or_sort_field
							end
						end
					}
				end
			}
		}

    # Now we'll MANUALLY create the domain browse list using the original_urls list
    unless facet_groups['original_urls'].nil?

			facet_groups['domain'] = Hash.new()

			facet_groups['original_urls'].each_pair{ |key, value|
				facet_groups['domain'][url_to_hoststring(key)] = value
			}

	  end

		###############################################################
		# Now we'll generate the browse_list file string from our hash
		###############################################################

		file_text = ''
    file_text += '# -*- encoding : utf-8 -*-' + "\n"
    file_text += '# This file was automatically generated on: ' + DateTime.now.to_s + "\n"
    file_text += 'module Hrwa::BrowseListHelper' + "\n"
    facet_groups.each_pair{|outer_key, outer_value|
			file_text += "def browse_list_for_#{outer_key}\n"
			file_text += "return {\n"
				outer_value.each_pair{|inner_key, inner_value|
					file_text += '%q{' + inner_key + '}'
					file_text += ' => %q{' + inner_value + '}'
					file_text += ",\n"
				}
			file_text += "}\n"
			file_text += "end\n\n"
		}
    file_text += "end\n"

		###############################################################
		# Done generating browse_list file string
		###############################################################

    wrote_the_file = false

    # Now we'll write this file to the disk
    begin
      #do important stuff
      File.open('app/helpers/hrwa/browse_list_helper.rb', 'w') {|f| f.write(file_text) }
      wrote_the_file = true
    rescue
      #handle error
    end

    return wrote_the_file
  end


	def url_to_hoststring(url)
		domain 		 = url.to_s.match( %r{ \A https?:// (?<domain> [^/]+ ) .* \Z }x )[ :domain ]
		hoststring = domain.sub( %r{ \A www [\w]? \. }x, '' )
		return hoststring
	end

end
