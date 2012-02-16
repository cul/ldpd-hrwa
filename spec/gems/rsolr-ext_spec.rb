require File.expand_path(File.dirname(__FILE__) + '/rsolr-ext_spec_helper')

describe 'RSolr::Ext' do

  context 'Response for Result-Grouped query' do

    def create_response
      raw_response = eval(mock_query_response_grouped)
      RSolr::Ext::Response::Base.new(raw_response, 'select', raw_response['params'])
    end

    it 'should have accurate total' do
      r = create_response
      r.total.should == 1064474
    end
    
    it 'should have accurate rows' do
      r = create_response
      r.rows.should == 10
    end    

    it 'should have accurate start' do
      r = create_response
      r.start.should == 0
    end    

    it 'should create a valid response' do
      r = create_response
      r.should respond_to(:header)
      r.ok?.should == true
    end

    # it 'should create a valid response class' do
      # r = create_response
# 
      # r.should respond_to(:response)
      # r.ok?.should == true
      # r.docs.size.should == 11
      # r.params[:echoParams].should == 'EXPLICIT'
#       
      # r.docs.previous_page.should == 1
      # r.docs.next_page.should == 2
      # r.docs.has_previous?.should == false
      # r.docs.has_next?.should == true
      # #
      # r.should be_a(RSolr::Ext::Response::Docs)
      # r.should be_a(RSolr::Ext::Response::Facets)
    # end
# 
    # it 'should create a doc with rsolr-ext methods' do
      # r = create_response
# 
      # doc = r.docs.first
      # doc.has?(:cat, /^elec/).should == true
      # doc.has?(:cat, 'elec').should_not == true
      # doc.has?(:cat, 'electronics').should == true
# 
      # doc.get(:cat).should == 'electronics, hard drive'
      # doc.get(:xyz).should == nil
      # doc.get(:xyz, :default=>'def').should == 'def'
    # end
# 
    # it 'should provide facet helpers' do
      # r = create_response
      # r.facets.size.should == 2
# 
      # field_names = r.facets.collect{|facet|facet.name}
      # field_names.include?('cat').should == true
      # field_names.include?('manu').should == true
# 
      # first_facet = r.facets.first
      # first_facet.name.should == 'cat'
# 
      # first_facet.items.size.should == 10
# 
      # expected = "electronics - 14, memory - 3, card - 2, connector - 2, drive - 2, graphics - 2, hard - 2, monitor - 2, search - 2, software - 2"
      # received = first_facet.items.collect do |item|
        # item.value + ' - ' + item.hits.to_s
      # end.join(', ')
# 
      # received.should == expected
# 
      # r.facets.each do |facet|
        # facet.respond_to?(:name).should == true
        # facet.items.each do |item|
          # item.respond_to?(:value).should == true
          # item.respond_to?(:hits).should == true
        # end
      # end
# 
    # end
# 
    # it 'should return the correct value when calling facet_by_field_name' do
      # r = create_response
      # facet = r.facet_by_field_name('cat')
      # facet.name.should == 'cat'
    # end
# 
    # it 'should provide the responseHeader params' do
      # raw_response = eval(mock_query_response)
      # raw_response['responseHeader']['params']['test'] = :test
      # r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', raw_response['params'])
      # r.params['test'].should == :test
    # end
# 
    # it 'should provide the solr-returned params and "rows" should be 11' do
      # raw_response = eval(mock_query_response)
      # r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      # r.params[:rows].to_s.should == '11'
    # end
# 
    # it 'should provide the ruby request params if responseHeader["params"] does not exist' do
      # raw_response = eval(mock_query_response)
      # raw_response.delete 'responseHeader'
      # r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', :rows => 999)
      # r.params[:rows].to_s.should == '999'
    # end
# 
    # it 'should provide spelling suggestions for regular spellcheck results' do
      # raw_response = eval(mock_response_with_spellcheck)
      # r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      # r.spelling.words.should include("dell")
      # r.spelling.words.should include("ultrasharp")
    # end
# 
    # it 'should provide spelling suggestions for extended spellcheck results' do
      # raw_response = eval(mock_response_with_spellcheck_extended)
      # r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      # r.spelling.words.should include("dell")
      # r.spelling.words.should include("ultrasharp")
    # end
# 
    # it 'should provide no spelling suggestions when extended results and suggestion frequency is the same as original query frequency' do
      # raw_response = eval(mock_response_with_spellcheck_same_frequency)
      # r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      # r.spelling.words.should == []
    # end
# 
    # it 'should provide spelling suggestions for a regular spellcheck results with a collation' do
      # raw_response = eval(mock_response_with_spellcheck_collation)
      # r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      # r.spelling.words.should include("dell")
      # r.spelling.words.should include("ultrasharp")
    # end
# 
    # it 'should provide spelling suggestion collation' do
      # raw_response = eval(mock_response_with_spellcheck_collation)
      # r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      # r.spelling.collation.should == 'dell ultrasharp'
    # end

  end

  context 'Response for non-Results-Grouped query' do

    def create_response
      raw_response = eval(mock_query_response)
      RSolr::Ext::Response::Base.new(raw_response, 'select', raw_response['params'])
    end

    it 'should create a valid response' do
      r = create_response
      r.should respond_to(:header)
      r.ok?.should == true
    end

    it 'should have accurate pagination numbers' do
      r = create_response
      r.rows.should == 11
      r.total.should == 26
      r.start.should == 0
      r.docs.per_page.should == 11
    end

    it 'should create a valid response class' do
      r = create_response

      r.should respond_to(:response)
      r.ok?.should == true
      r.docs.size.should == 11
      r.params[:echoParams].should == 'EXPLICIT'
      
      r.docs.previous_page.should == 1
      r.docs.next_page.should == 2
      r.docs.has_previous?.should == false
      r.docs.has_next?.should == true
      #
      r.should be_a(RSolr::Ext::Response::Docs)
      r.should be_a(RSolr::Ext::Response::Facets)
    end

    it 'should create a doc with rsolr-ext methods' do
      r = create_response

      doc = r.docs.first
      doc.has?(:cat, /^elec/).should == true
      doc.has?(:cat, 'elec').should_not == true
      doc.has?(:cat, 'electronics').should == true

      doc.get(:cat).should == 'electronics, hard drive'
      doc.get(:xyz).should == nil
      doc.get(:xyz, :default=>'def').should == 'def'
    end

    it 'should provide facet helpers' do
      r = create_response
      r.facets.size.should == 2

      field_names = r.facets.collect{|facet|facet.name}
      field_names.include?('cat').should == true
      field_names.include?('manu').should == true

      first_facet = r.facets.first
      first_facet.name.should == 'cat'

      first_facet.items.size.should == 10

      expected = "electronics - 14, memory - 3, card - 2, connector - 2, drive - 2, graphics - 2, hard - 2, monitor - 2, search - 2, software - 2"
      received = first_facet.items.collect do |item|
        item.value + ' - ' + item.hits.to_s
      end.join(', ')

      received.should == expected

      r.facets.each do |facet|
        facet.respond_to?(:name).should == true
        facet.items.each do |item|
          item.respond_to?(:value).should == true
          item.respond_to?(:hits).should == true
        end
      end

    end

    it 'should return the correct value when calling facet_by_field_name' do
      r = create_response
      facet = r.facet_by_field_name('cat')
      facet.name.should == 'cat'
    end

    it 'should provide the responseHeader params' do
      raw_response = eval(mock_query_response)
      raw_response['responseHeader']['params']['test'] = :test
      r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', raw_response['params'])
      r.params['test'].should == :test
    end

    it 'should provide the solr-returned params and "rows" should be 11' do
      raw_response = eval(mock_query_response)
      r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      r.params[:rows].to_s.should == '11'
    end

    it 'should provide the ruby request params if responseHeader["params"] does not exist' do
      raw_response = eval(mock_query_response)
      raw_response.delete 'responseHeader'
      r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', :rows => 999)
      r.params[:rows].to_s.should == '999'
    end

    it 'should provide spelling suggestions for regular spellcheck results' do
      raw_response = eval(mock_response_with_spellcheck)
      r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      r.spelling.words.should include("dell")
      r.spelling.words.should include("ultrasharp")
    end

    it 'should provide spelling suggestions for extended spellcheck results' do
      raw_response = eval(mock_response_with_spellcheck_extended)
      r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      r.spelling.words.should include("dell")
      r.spelling.words.should include("ultrasharp")
    end

    it 'should provide no spelling suggestions when extended results and suggestion frequency is the same as original query frequency' do
      raw_response = eval(mock_response_with_spellcheck_same_frequency)
      r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      r.spelling.words.should == []
    end

    it 'should provide spelling suggestions for a regular spellcheck results with a collation' do
      raw_response = eval(mock_response_with_spellcheck_collation)
      r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      r.spelling.words.should include("dell")
      r.spelling.words.should include("ultrasharp")
    end

    it 'should provide spelling suggestion collation' do
      raw_response = eval(mock_response_with_spellcheck_collation)
      r = RSolr::Ext::Response::Base.new(raw_response, '/catalog', {})
      r.spelling.collation.should == 'dell ultrasharp'
    end

  end

end

