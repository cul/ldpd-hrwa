require 'spec_helper'
require 'advanced_search'

class MockCatalogController
  include AdvancedSearch 
end

mock_catalog_controller = MockCatalogController.new

describe 'process_q_and' do
  it 'prepends plus sign to each term and appends correctly to q param' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_and => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_and solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo +women's +rights +africa}
  end
  
  it 'gracefully exits if q_and is nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_and => nil }
    
    mock_catalog_controller.process_q_and solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
  
  it 'gracefully exits if q_and is blank but non-nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_and => %q{} }
    
    mock_catalog_controller.process_q_and solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
    
  it 'gracefully exits if q_and is all whitespace but non-nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_and => %q{   } }
    
    mock_catalog_controller.process_q_and solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
  
  it 'does not add a space to beginning of q param if q param was empty' do
    solr_parameters = { :q => nil }
    user_parameters = { :q_and => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_and solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{+women's +rights +africa}
  end
end

describe 'process_q_exclude' do
  it 'prepends minus sign to each term and appends correctly to q param' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_exclude => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_exclude solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo -women's -rights -africa}
  end
  
  it 'gracefully exits if q_exclude is nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_exclude => nil }
    
    mock_catalog_controller.process_q_exclude solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
  
  it 'gracefully exits if q_exclude is blank but non-nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_exclude => %q{} }
    
    mock_catalog_controller.process_q_exclude solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
    
  it 'gracefully exits if q_exclude is all whitespace but non-nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_exclude => %q{   } }
    
    mock_catalog_controller.process_q_exclude solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
  
  it 'does not add a space to beginning of q param if q param was empty' do
    solr_parameters = { :q => nil }
    user_parameters = { :q_exclude => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_exclude solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{-women's -rights -africa}
  end
end

describe 'process_q_or' do
  it 'leaves all terms as is, because SOLR default is OR' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_or => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_or solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo women's rights africa}
  end
  
  it 'gracefully exits if q_or is nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_or => nil }
    
    mock_catalog_controller.process_q_or solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
  
  it 'gracefully exits if q_or is blank but non-nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_or => %q{} }
    
    mock_catalog_controller.process_q_or solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
    
  it 'gracefully exits if q_or is all whitespace but non-nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_or => %q{   } }
    
    mock_catalog_controller.process_q_or solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
  
  it 'does not add a space to beginning of q param if q param was empty' do
    solr_parameters = { :q => nil }
    user_parameters = { :q_or => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_or solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{women's rights africa}
  end
end

describe 'process_q_phrase' do
  it 'wraps whole textbox input in double quotes' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_phrase => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_phrase solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo "women's rights africa"}
  end
  
  it 'gracefully exits if q_phrase is nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_phrase => nil }
    
    mock_catalog_controller.process_q_phrase solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
  
  it 'gracefully exits if q_phrase is blank but non-nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_phrase => %q{} }
    
    mock_catalog_controller.process_q_phrase solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
    
  it 'gracefully exits if q_phrase is all whitespace but non-nil and leaves q param untouched' do
    solr_parameters = { :q => 'ngo' }
    user_parameters = { :q_phrase => %q{   } }
    
    mock_catalog_controller.process_q_phrase solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{ngo}
  end
  
  it 'does not add a space to beginning of q param if q param was empty' do
    solr_parameters = { :q => nil }
    user_parameters = { :q_phrase => %q{women's rights africa} }
    
    mock_catalog_controller.process_q_phrase solr_parameters, user_parameters
    
    solr_parameters[ :q ].should eq %q{"women's rights africa"}
  end
end
