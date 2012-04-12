module HRWA::Catalog::Dev
  extend ActiveSupport::Concern

  def get_solr_host_from_url(search_type, localized_params = params)
    if(search_type == 'archive')
			if localized_params[:hrwa_host] == 'dev'
				'http://carter.cul.columbia.edu:8080/solr-4/asf'
			elsif localized_params[:hrwa_host] == 'test'
				'http://harding.cul.columbia.edu:8080/solr-4/asf'
			elsif localized_params[:hrwa_host] == 'prod'
				'http://machete.cul.columbia.edu:8181/solr-4/asf'
			end
    elsif(search_type == 'find_site')
			if localized_params[:hrwa_host] == 'dev'
				'http://carter.cul.columbia.edu:8080/solr-4/fsf'
			elsif localized_params[:hrwa_host] == 'test'
				'http://harding.cul.columbia.edu:8080/solr-4/fsf'
			elsif localized_params[:hrwa_host] == 'prod'
				'http://machete.cul.columbia.edu:8181/solr-4/fsf'
			end
    end
  end

end
