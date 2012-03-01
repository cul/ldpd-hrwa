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
    fill_in 'q_and', :with => 'water'
    click_button 'submit_search'
    page.has_field?( 'q', :with => '[Click + to refine search]' ).should == true
  end

  it 'returns search results for a known successful query' do
    visit '/advanced_fsf'
    fill_in 'q_and', :with => 'water'
    fill_in 'q_phrase', :with => 'Provides information'
    fill_in 'q_or', :with => 'human rights'
    fill_in 'q_exclude', :with => 'zamboni'
    click_button 'submit_search'
    page.should have_content('Center for Economic and Social Rights')
  end

end

# JIRA issue: https://issues.cul.columbia.edu/browse/HRWA-324
# CatalogController is apparently re-used.  If blacklight_config of the CatalogController
# is not reset to a blank state reset to blank state in each request, there is 
# the potential for a SOLR error to occur due to old stuff such as config.facet_fields and
# config.sort_fields defined in the previous request referencing SOLR fields that don't exist in the
# SOLR index for the current search_type.
#
# Example: It used to be that archive search had sort='score desc, dateOfCaptureYYYYMMDD desc'
# find_site had sort='score desc'.  If there was no sort param in the HTTP query string
# then the FindSiteSearchConfigurator would attempt to set the sort field to 
# 'score desc, dateOfCaptureYYYYMMDD desc', causing a SOLR error.
#
# TODO: change this to use form fill-in when JS seleniun is working on bronte
describe 'the portal search' do
  it 'can successfully run a find_site search immediately after an archive search' do
    visit '/search?search_type=archive&q=women&search_mode=simple'
    page.should have_content( 'Displaying results' ) 

    visit '/search?search_type=find_site&women&search_mode=simple'
    page.should_not have_content( 'RSolr::Error' )
  end
end

# describe 'advanced_search_version_of_default_search_form' do
#
  # it 'returns search results for a known successful query' do
#
    # visit '/search'
#
    # click_link 'advo_link'
    # fill_in 'q_and', :with => 'water'
    # fill_in 'q_phrase', :with => 'Provides information'
    # fill_in 'q_or', :with => 'human rights'
    # fill_in 'q_exclude', :with => 'zamboni'
    # click_button 'advsubmit'
    # page.should have_content('Center for Economic and Social Rights')
  # end
#
# end

# TODO: change this for form fill-in
describe 'archive search' do
  it 'does not raise an error when paging through results' do
    visit '/catalog?page=3&q=water&search_type=archive'
    page.should_not have_content( %q{can't convert Fixnum into String} )
  end
end
