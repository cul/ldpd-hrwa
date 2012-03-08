require 'spec_helper'

describe 'home page' do
  it 'loads with the correct text' do
    visit '/'
    page.should have_content('Human Rights Web Archive')
  end

  it 'checks the default top bar search checkbox when type param absent or blank, or non-default' do
    visit '/'
    page.has_checked_field?('#fsfsearch_t')
    visit '/?type=find_site'
    page.has_checked_field?('#fsfsearch_t')
    visit '/?type=zzz'
    page.has_checked_field?('#fsfsearch_t')
    visit '/?type='
    page.has_checked_field?('#fsfsearch_t')
    visit '/?type=\'\''
    page.has_checked_field?('#fsfsearch_t')
  end

  it 'checks the archive search top bar checkbox when supplied with query param type=archive' do
    visit '/?type=archive'
    page.has_checked_field?('#asfsearch_t')
  end
end

describe 'about page' do
  it 'loads with the correct text' do
    visit '/about'
    page.should have_content('About the Project')
  end
end

describe 'collection browse page' do
  it 'loads with the correct text' do
    visit '/browse'
    page.should have_content('Collection Browse')
  end
end
