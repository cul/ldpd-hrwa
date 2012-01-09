require 'test_helper'

class CatalogControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  test "should display a homepage" do
    get :index
    assert_response :success
  end

  test "should display 10 documents by default" do
    get :index, :q => "journalists documents bosnia"
    assert_response :success

    assert_select "#documents" do 
      assert_select '.document', 10
    end 
  end

  test "the title link should go to the external url" do
    get :index, :q => "journalists documents bosnia"
    assert_response :success

    assert_select '.document .index_title a' do |element|
      assert !(element.to_s.include?('href="/catalog"'))

    end
    
  end


end

