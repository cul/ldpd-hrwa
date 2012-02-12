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
end

describe 'advanced_search' do
  # Advanced search doesn't use 'q' param, and when q is missing Blacklight often by default sends user to Home view
  # We are overriding so that if 'q' is absent but 'q_*' param(s) are present, the index view still
  # gets rendered.  It might be the case that we put in a "dummy" 'q' user param, but just in case...
  it 'informs user "No results found" if advanced search returns no hits' do
    visit '/search?type=archive&search_mode=advanced&q_and=and1+and2+and3'
  end
  
  it 'informs user "Click on + to refine search" in simple search box if doing advanced search' do
    visit '/search?type=archive&search_mode=advanced&q_and=and1+and2+and3'
    page.has_field?( 'q', :with => 'Click + to refine search' )
  end
  
  # This should never really happen, but just in case...
  it 'renders the search page if there are no q_* or limit by params (if the are present' +
     ' that is a different use case)' do
     visit '/search?'
     page.should have_content('Search Tips')
  end
 
end