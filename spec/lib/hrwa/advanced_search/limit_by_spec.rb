require 'spec_helper'

class MockCatalogController
  include HRWA::AdvancedSearch::LimitBy
  attr_accessor :params
end

mock_catalog_controller = MockCatalogController.new

describe 'HRWA::AdvancedSearch::LimitBy' do
  before( :each ) do
    mock_catalog_controller.params = { :search_type => 'archive', :search_mode => 'advanced', :q_and => '', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search', }
    @solr_parameters = { }
  end
  
  describe '#limit_by_user_params' do

    it 'returns empty hash if no lim_* user params present' do
      mock_catalog_controller.limit_by_user_params.should == {}
    end
    
    it 'returns hash of lim_* user params if present' do
      lim_params = { :lim_domain => 'advocacyforum.org', :lim_language => 'English' }
      mock_catalog_controller.params.merge!( lim_params )
      mock_catalog_controller.limit_by_user_params.should == lim_params
    end

  end
 
  describe '#add_limit_by_filter_queries_to_solr' do

    it 'creates filter query correctly for domain limit-by' do
      mock_catalog_controller.params[ :lim_domain ] = 'advocacyforum.org'
      mock_catalog_controller.add_limit_by_filter_queries_to_solr( @solr_parameters )
      @solr_parameters[ :fq ].should == [ 'domain:advocacyforum.org' ]
    end
    
    it 'creates filter query correctly for multiple domain limit-by\'s' do
      mock_catalog_controller.params[ :lim_domain ] = [ 'advocacyforum.org', 'justice.gov.za', 'amnistia.org.mx' ]
      mock_catalog_controller.add_limit_by_filter_queries_to_solr( @solr_parameters )
      @solr_parameters[ :fq ].should == [ 'domain:advocacyforum.org', 'domain:justice.gov.za', 'domain:amnistia.org.mx' ]
    end
   
  end
  
end
