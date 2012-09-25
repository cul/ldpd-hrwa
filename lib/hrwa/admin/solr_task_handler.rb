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

														'creator_name__facet' => -1,
														'organization_based_in__facet' => -1,
														'organization_type__facet' => -1,

                            :rows => 0,
                          }

    file_text = ''
    file_text += '# -*- encoding : utf-8 -*-' + "\n"
    file_text += '# This file was automatically generated on: ' + DateTime.now.to_s + "\n"
    file_text += 'module Hrwa::BrowseListHelper' + "\n"

    original_urls_for_domain_converstion = nil
    found_original_urls_group = false

    @response['facet_counts']['facet_fields'].each{ | facet_type_or_group_of_facets |
      facet_type_or_group_of_facets.each{ |facet_name_or_group|
        if facet_name_or_group.is_a?(String)
          file_text += "def browse_list_for_#{facet_name_or_group}\n"

					# Since original_urls is a special case, we'll identify when we find the 'original_urls' group so we can capture it the next time the else statement below runs
          if(facet_name_or_group == 'original_urls')
						found_original_urls_group = true
					end

        else
          file_text += "return {\n"
          facet_name_or_group.each_with_index{ |facet_name_or_sort_field, index|
            if(index%2 == 0)
              file_text += '%q{' + facet_name_or_sort_field + '}'
            else
              if(facet_name_or_sort_field.is_a?(Fixnum))
                file_text += ' => ' + facet_name_or_sort_field.to_s
              else
                file_text += ' => %q{' + facet_name_or_sort_field + '}'
              end
              file_text += ",\n"
            end
          }
          file_text += "}\n"
          file_text += "end\n\n"

          # We'll save the original_urls group so that it can be used at the end for generating the domain list
          if(found_original_urls_group)
						original_urls_for_domain_converstion = facet_name_or_group
						found_original_urls_group = false # because we don't want this if block to run more than once
          end

        end
      }
    }

    # Now we'll MANUALLY create the domain browse list using the original_urls list
    unless original_urls_for_domain_converstion.nil?

			#hoststrings = original_urls_for_domain_converstion.each.map { | url |
			#	domain     = url.to_s.match( %r{ \A https?:// (?<domain> [^/]+ ) .* \Z }x )[ :domain ]
			#	hoststring = domain.sub( %r{ \A www [\w]? \. }x, '' )
			#	hoststring
			#}

			file_text += "def browse_list_for_domain\n"
			file_text += "return {\n"

			original_urls_for_domain_converstion.each_with_index{ |facet_name_or_sort_field, index|
				if(index%2 == 0)
					file_text += '%q{' + url_to_hoststring(facet_name_or_sort_field) + '}'
				else
					if(facet_name_or_sort_field.is_a?(Fixnum))
						file_text += ' => ' + facet_name_or_sort_field.to_s
					else
						file_text += ' => %q{' + facet_name_or_sort_field + '}'
					end
					file_text += ",\n"
				end
			}

	    file_text += "}\n"
      file_text += "end\n\n"
	  end

    file_text += "end\n"

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
