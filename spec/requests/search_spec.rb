require 'spec_helper'

# TODO: re-enable the three disabled tests below

describe 'all searches' do
  it 'should not have "host" param in querystring' do
    visit '/advanced_asf'
    fill_in 'q_and', :with => 'woman'
    click_button 'submit_search'

    querystring = URI.parse( current_url ).query
    params_hash = Rack::Utils.parse_nested_query( querystring ).deep_symbolize_keys
    params_hash[ :host ].should be_nil
  end
  
  it 'render the "search home page" if there are no params' do
    visit '/search'
    page.should have_content('Search Tips')
  end
end

describe 'advanced_search_asf' do
  it 'informs user "No results found" if advanced search returns no hits' do
    visit '/advanced_asf'
    fill_in 'q_and', :with => 'zzzzzzzzzzzzzzzzzzaaaaaaaaaaaaaaaa'
    click_button 'submit_search'
    page.should have_content('No results found')
  end
 
  it 'informs user "Click on + to refine search" in simple search box if doing advanced search' do
    visit '/advanced_asf'
    fill_in 'q_and', :with => 'women'
    click_button 'submit_search'
    page.has_field?( 'q', :with => 'Click + to refine search' ).should == true
  end

end
