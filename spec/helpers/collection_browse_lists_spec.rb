# -*- encoding : utf-8 -*-
require 'spec_helper'

include HRWA::CollectionBrowseLists

describe 'HRWA::CollectionBrowseLists' do
  before :all do
    require_relative 'fixtures/collection_browse_lists_source_hardcoded'
    include HRWA::CollectionBrowseListsSourceHardcoded
  end
  
  describe '#*_browse_list methods' do
    browse_categories = {
                           'creator_name'          => 493,
                           'geographic_focus'      => 161,
                           'language'              => 64,
                           'organization_based_in' => 132,
                           'organization_type'     => 4,
                           'original_urls'         => 506,
                           'subject'               => 311,
                        }

      browse_categories.each { | browse_category, count |
        it "retrieves full #{ browse_category } browse list" do
          browse_list = send( "#{ browse_category }_browse_list" )
          browse_list.length.should == count
        end
      }
  end

  describe '#browse_list' do
    it 'raises an error when passed an unknown browse category' do
      expect{ browse_list( 'xxx' ) }.to raise_error( ArgumentError )
    end
  end
  
end
