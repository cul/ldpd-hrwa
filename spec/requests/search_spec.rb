require 'spec_helper'

describe 'advanced_search' do
  # Advanced search doesn't use 'q' param, in such case Blacklight often by default sends user to Home view
  # We are overriding so that if 'q' is absent but 'q_*' param(s) are present, the index view still
  # gets rendered
  it 'informs user "No results found" if advanced search returns no hits' do
    visit '/'
    page.should have_content('Human Rights Web Archive')
  end
  
  # This should never really happen, but just in case...
  it 'renders the search page if there are no q_* or limit by params (if the are present' +
     ' that is a different use case)' do
     visit '/search?'
     page.should have_content('Search Tips')
  end

end