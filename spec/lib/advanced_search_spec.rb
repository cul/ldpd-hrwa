require 'spec_helper'
require 'advanced_search'

class MockCatalogController
  def self.solr_search_params_logic 
    return [ ]
  end
  
  include AdvancedSearch 
end

describe 'process_q_and' do
  it 'prepends plus sign before each term' do
    solr_parameters = { :q => '' }
    user_parameters = { :q_and => "women's rights africa" }
    
    MockCatalogController::process_q_and solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq " +women's +rights +africa"
  end
end

# describe 'process_q_or' do
  # it '?' do
#     
  # end
# end
# 
# describe 'process_q_phrase' do
  # it 'wraps whole textbox input in double quotes' do
#     
  # end
# end
# 
# describe 'process_q_exclude' do
  # it 'prepends minus sign before each term' do
#     
  # end
# end
