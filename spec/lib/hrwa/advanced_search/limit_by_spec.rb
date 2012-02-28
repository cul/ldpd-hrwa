require 'spec_helper'

class MockCatalogController
  include HRWA::AdvancedSearch::LimitBy
end

mock_catalog_controller = MockCatalogController.new

# describe 'HRWA::AdvancedSearch::LimitBy' do
  # before( :each ) do
    # @solr_parameters = {  }
  # end
#   
  # describe '#translate_limit_by_param_to_solr_param' do
#     
    # it 'creates filter query correctly for domain limit-by' do
      # user_parameters = { :search_type => 'archive', :search_mode => 'advanced', :q_and => '', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => 'advocacyforum.org', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search', }
      # mock_catalog_controller.add_limit_by_domain @solr_parameters, user_parameters
      # @solr_parameters[ :fq ].should eq %q{ 'domain:advocacyforum.org' }
    # end
#     
  # end
# end
