# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'home page' do
  it 'loads with the correct text' do
    visit '/'
    page.should have_content('Center for Human Rights Documentation & Research at Columbia University')
  end

  it 'checks the default top bar search checkbox' do
    visit '/'
    page.has_checked_field?('#fsfsearch')
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

describe 'public nomination page' do
  it 'loads with the correct text' do
    visit '/public_nomination'
    page.should have_content('Nominate a Site')
  end
end

describe 'owner nomination page' do
  it 'loads with the correct text' do
    visit '/owner_nomination'
    page.should have_content('Nominate Your Site')
  end
end
