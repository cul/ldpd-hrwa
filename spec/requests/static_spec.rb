require 'spec_helper'

describe 'home page' do
  it 'loads with the correct text' do
    visit '/'
    page.should have_content('Human Rights Web Archive')
  end
end

describe 'about page' do
  it 'loads with the correct text' do
    visit '/about'
    page.should have_content('About the Project')
  end
end

describe 'contact page' do
  it 'loads with the correct text' do
    visit '/contact'
    page.should have_content('Hello Contact Page!')
  end
end

describe 'collection browse page' do
  it 'loads with the correct text' do
    visit '/browse'
    page.should have_content('Collection Browse')
  end
end

describe 'faq page' do
  it 'loads with the correct text' do
    visit '/faq'
    page.should have_content('Hello FAQ Page!')
  end
end
