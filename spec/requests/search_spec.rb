require 'spec_helper'

# TODO: enable this test
describe 'all searches' do
  it 'use correct host when building URLs for facets' do
    visit '/search?type=archive&search_mode=advanced&q_and=women&q_phrase=&q_or=&q_exclude=&lim_domain=&lim_mimetype=&lim_language=&lim_geographic_focus=&lim_organization_based_in=&lim_organization_type=&lim_creator_name=&crawl_start_date=&crawl_end_date=&rows=10&sort=score+desc&path=%2Fsolr-4%2Fasf&submit_search=Advanced+Search'
    # page.should # NOT see SOLR host, should see Web host
  end
end

describe 'advanced_search' do
  # Advanced search doesn't use 'q' param, and when q is missing Blacklight often by default sends user to Home view
  # We are overriding so that if 'q' is absent but 'q_*' param(s) are present, the index view still
  # gets rendered.  It might be the case that we put in a "dummy" 'q' user param, but just in case...
  it 'informs user "No results found" if advanced search returns no hits' do
    visit '/search?type=archive&search_mode=advanced&q_and=and1+and2+and3'
  end
  
  # TODO: enable this test
  # it 'informs user "Click on + to refine search" in simple search box if doing advanced search' do
    # visit '/search?type=archive&search_mode=advanced&q_and=and1+and2+and3'
    # page.should have_content('Click + to refine search')
  # end
  
  # This should never really happen, but just in case...
  it 'renders the search page if there are no q_* or limit by params (if the are present' +
     ' that is a different use case)' do
     visit '/search?'
     page.should have_content('Search Tips')
  end
 
end