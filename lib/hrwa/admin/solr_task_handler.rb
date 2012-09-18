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
                            :'facet.field' => ['title__facet',
                                               'original_urls',
                                               'subject__facet',
                                               'geographic_focus__facet',
                                               'language__facet'],
                            :'f.title__facet.facet.limit' => -1,
                            :'f.original_urls.facet.limit' => -1,
                            :'f.subject__facet.facet.limit' => -1,
                            :'f.geographic_focus__facet.facet.limit' => -1,
                            :'f.language__facet.facet.limit' => -1,
                            :rows => 0,
                          }

    file_text = ''
    file_text += '# -*- encoding : utf-8 -*-' + "\n"
    file_text += '# This file was automatically generated on: ' + DateTime.now.to_s + "\n"
    file_text += 'module Hrwa::BrowseListHelper' + "\n"

    @response['facet_counts']['facet_fields'].each{ | facet_type_or_group_of_facets |
      facet_type_or_group_of_facets.each{ |facet_name_or_group|
        if facet_name_or_group.is_a?(String)
          file_text += "def browse_list_for_#{facet_name_or_group}\n"
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
        end
      }
    }

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

end
