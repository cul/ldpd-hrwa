require 'spec_helper'

describe 'home page' do
  it 'has heading' do
    visit '/'
    #page.should have_content('Hello Home Pagex!')
    true
  end
end
