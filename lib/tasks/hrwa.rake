def reindex(dc_id)
  ContentAggregator.find_by_identifier(dc_id).send(:update_index)
end
namespace :ldpd do
  namespace :hrwa do

    task :reindex_by_id => :environment do
      if (ENV["DCID"])
        reindex(ENV["DCID"])
      elsif (ENV["DCID_LIST"])
        File.open(ENV["DCID_LIST"]).each do |line|
          reindex(line.strip)
        end
      end
    end

    task :reindex => :environment do

      solrTaskHandler = Hrwa::Admin::SolrTaskHandler.new
      start_item_number = 1

      if(!ENV["RAILS_ENV"])
        puts "\nError: Please specify a RAILS_ENV.\n"
        return
      end

      if(ENV["START_AT"])
        if( ! ENV["START_AT"].match(/\A[0-9]+\Z/) )
          puts "\nError: Invalid value for START_AT. Must be a number.\n"
          return
        end
        start_item_number = ENV["START_AT"].to_i
      else

      end

      if(ENV["XML_FILE"])
        if( ! File.exists?(ENV["XML_FILE"]) )
          puts "\nError: Could not find the specified XML_FILE: " + ENV["XML_FILE"] + "\n"
          return
        end
        solrTaskHandler.reindex_solr_from_xml_file(start_item_number, ENV["XML_FILE"])
      else
        solrTaskHandler.reindex_solr_from_xml_file(start_item_number)
      end

    end

  end
end
