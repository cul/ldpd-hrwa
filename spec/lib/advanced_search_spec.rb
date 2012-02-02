require 'spec_helper'
require 'advanced_search'

class MockCatalogController
  def self.solr_search_params_logic 
    return [ ]
  end
  
  include AdvancedSearch 
end

mock_catalog_controller = MockCatalogController.new

describe 'process_q_and' do
  it 'prepends plus sign before each term' do
    solr_parameters = { :q => '' }
    user_parameters = { :q_and => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_and solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ +women's +rights +africa}
  end
end

describe 'process_q_or' do
  it 'leaves all terms as is, because SOLR default is OR' do
    solr_parameters = { :q => '' }
    user_parameters = { :q_or => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_or solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ women's rights africa}
  end
end

describe 'process_q_phrase' do
  it 'wraps whole textbox input in double quotes' do
    solr_parameters = { :q => '' }
    user_parameters = { :q_phrase => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_phrase solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ "women's rights africa"}
  end
end

describe 'process_q_exclude' do
  it 'prepends minus sign before each term' do
    solr_parameters = { :q => '' }
    user_parameters = { :q_exclude => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_exclude solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ -women's -rights -africa}
  end
end
