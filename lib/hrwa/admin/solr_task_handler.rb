require 'rsolr'
require 'nokogiri'
require 'active_support'
class Hrwa::Admin::SolrTaskHandler
	#unloadable
  NOKO_NS = {'mods' => 'http://www.loc.gov/mods/v3'}

  def initialize
		@solr_url = YAML.load_file('config/solr.yml')[Rails.env]['url']
		@fedora_url = YAML.load_file('config/fedora.yml')[Rails.env]['url']

		@rsolr = RSolr.connect :url => @solr_url
  end

  def clear_solr_index()

		begin
			clear_index_result = (@rsolr.delete_by_query '*:*')['responseHeader']['status'] == 0
			@rsolr.commit
			@rsolr.optimize
		rescue => ex
			Rails.logger.debug('clear_solr_index() error: ' + ex);
			clear_index_result = nil #result should be considered invalid if an error occurred
		end

		return clear_index_result

  end

  def update_hardcoded_browse_lists

    @response = @rsolr.get 'select',
                          :params => {
                            :q  => '*:*',
                            :qt => 'search',
                            :facet => true,
                            :'facet.field' => ['subject_geographic__facet',
                                               'topic_subject__facet',
                                               'associated_name__facet',
                                               'subject_name__facet'],
                            :'f.subject_geographic__facet.facet.limit' => -1,
                            :'f.topic_subject__facet.facet.limit' => -1,
                            :'f.associated_name__facet.facet.limit' => -1,
                            :'f.subject_name__facet.facet.limit' => -1,
                            :rows => 0,
                          }

    file_text = ''
    file_text += '# -*- encoding : utf-8 -*-' + "\n"
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

  def reindex_solr_from_xml_file(one_indexed_start_item_number = 1, xml_file_location = 'extras/lindquist.xml')

    start_time = Time.now # For displaying reindex time

    zero_indexed_start_item_number = one_indexed_start_item_number-1

    puts('---------------------------- BEGIN REINDEX ----------------------------')
    puts('-----------------------------------------------------------------------')
    puts('-----------------------------------------------------------------------')
    puts('----------------------------- ENVIRONMENT -----------------------------')
    puts(Rails.env)
    puts('-----------------------------------------------------------------------')
    puts('------------------------------ SOLR URL -------------------------------')
    puts(@solr_url)
    puts('-----------------------------------------------------------------------')
    puts('----------------------------- FEDORA URL ------------------------------')
    puts(@fedora_url)
    puts('-----------------------------------------------------------------------')

		begin

			doc = Nokogiri::XML( File.open(xml_file_location) )

			counter = 0

			docs = doc.xpath('/mods:modsCollection/mods:mods', NOKO_NS)

			docs_count = docs.length

			docs.each do |node|

        if counter < zero_indexed_start_item_number
          counter += 1
          next
        end

			  _id = node.xpath('./mods:identifier[@type=\'local\']', NOKO_NS).text
        agg = ContentAggregator.find_by_identifier(_id)
        unless agg.blank? # not going to create unexpected objects... yet
          node.default_namespace = 'http://www.loc.gov/mods/v3'
          new_content = node.to_xml
          old_content = agg.descMetadata.content
          unless new_content == old_content || new_content.strip == old_content.strip
            agg.descMetadata.content= new_content
            content_changed = true
          end
          if agg.datastreams['rightsMetadata'].new?
            agg.datastreams["rightsMetadata"].ng_xml = Hydra::RightsMetadata.xml_template
            content_changed = true
          end
          if content_changed
            agg.save
          else
            agg.send :update_index
          end
				  counter = counter + 1
        end
        puts 'Indexed item ' + counter.to_s + ' of ' + docs_count.to_s + ' - Current run time: ' + (Time.now-start_time).to_i.to_s + ' seconds'
			end

			# Also optimize because hey, who doesn't like optimizing?
			ActiveFedora::SolrService.instance.conn.optimize

			doc_add_result = true #success

		rescue => ex
			Rails.logger.debug('reindex_solr_from_xml_file() error: ' + ex.to_s);
			puts ex.message
			puts ex.backtrace
			doc_add_result = nil #result should be considered invalid if an error occurred
		end

		puts('-------------------- END REINDEX --------------------')
		puts('Total reindexing time: ' + (Time.now-start_time).to_s)
		puts('--------------------------------------------------')

		#TODO: Finish this
		return doc_add_result

  end

end
