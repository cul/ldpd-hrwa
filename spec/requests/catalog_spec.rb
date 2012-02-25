require 'spec_helper'

describe 'all searches' do
  it 'should not have "host" param in querystring' do
    visit '/advanced_asf'
    fill_in 'q_and', :with => 'woman'
    click_button 'submit_search'

    querystring = URI.parse( current_url ).query
    params_hash = Rack::Utils.parse_nested_query( querystring ).deep_symbolize_keys
    params_hash[ :host ].should be_nil
  end

  #it 'render the "search home page" if there are no params' do
  #  visit '/search'
  #  page.should have_content('Search Tips')
  #end
end

describe 'advanced_search_asf' do
  it 'informs user "No results found" if advanced search returns no hits' do
    visit '/advanced_asf'
    fill_in 'q_and', :with => 'zzzzzzzzzzzzzzzzzzaaaaaaaaaaaaaaaa'
    click_button 'submit_search'
    page.should have_content('No results found')
  end

  describe 'q_and=women search' do
    before :each do
      visit '/advanced_asf'
      fill_in 'q_and', :with => 'women'
      click_button 'submit_search'
      @result_page = page
    end

    it 'informs user "Click on + to refine search" in simple search box if doing advanced search' do
      @result_page.has_field?( 'q', :with => '[Click + to refine search]' ).should == true
    end
  
    it 'creates the correct HTTP querystring for simple "q_and" search' do
      querystring = URI.parse( current_url ).query
      querystring.should == "search_type=archive&search_mode=advanced&q_and=women&q_phrase=&q_or=&q_exclude=&lim_domain=&lim_mimetype=&lim_language=&lim_geographic_focus=&lim_organization_based_in=&lim_organization_type=&lim_creator_name=&crawl_start_date=&crawl_end_date=&rows=10&sort=score+desc&solr_host=harding.cul.columbia.edu&solr_core_path=%2Fsolr-4%2Fasf&submit_search=Advanced+Search"
    end
  
    # TODO: These are just some cheap, temporary tests for assistance during initial development.
    # SOLR index is stable but later will be incrementally updated so these tests are super-brittle.
    # Delete them when Rails Port milestone is reached.
    it 'returns 3,262,426 results for q_and=women (TEMPORARY TEST: DELETE ME LATER)' do
      @result_page.should have_content( '3,262,426' )
    end

  end

end

describe 'advanced_search_fsf' do
  
  it 'informs user "No results found" if advanced search returns no hits' do
    visit '/advanced_fsf'
    fill_in 'q_and', :with => 'zzzzzzzzzzzzzzzzzzaaaaaaaaaaaaaaaa'
    click_button 'submit_search'
    page.should have_content('No results found')
  end

  it 'informs user "Click on + to refine search" in simple search box if doing advanced search' do
    visit '/advanced_fsf'
    fill_in 'q_and', :with => 'women'
    click_button 'submit_search'
    page.has_field?( 'q', :with => '[Click + to refine search]' ).should == true
  end

end
