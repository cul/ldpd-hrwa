namespace :ldpd do
  namespace :hrwa do

    task :updatebrowselists => :environment do

      solrTaskHandler = Hrwa::Admin::SolrTaskHandler.new
      solrTaskHandler.update_hardcoded_browse_lists

    end

  end
end
