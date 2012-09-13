# -*- encoding : utf-8 -*-
require 'spec_helper'

include Hrwa::CollectionBrowseLists

def setup_unit_test_collection_browse_lists
  require_relative 'fixtures/collection_browse_lists_source_hardcoded'
  include Hrwa::CollectionBrowseListsSourceHardcoded
end

def load_tiny_collection_browse_lists
  # Load different fixture file with browse lists of short length for quick test of load
  Hrwa::CollectionBrowseLists.load_browse_lists( 'helpers/fixtures/collection_browse_lists_source_hardcoded_reload.rb' )
end

def expected_reloaded_browse_list_length
  return 1
end

def browse_categories
  return {
             'geographic_focus'      => 157,
             'language'              => 60,
             'organization_based_in' => 130,
             'original_urls'         => 458,
             'subject'               => 271,
             'title'                 => 440,
         }
end

describe 'Hrwa::CollectionBrowseLists' do
  before :all do
    setup_unit_test_collection_browse_lists
  end

  describe '#*_browse_list methods' do
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

  # Regression test for https://issues.cul.columbia.edu/browse/HRWA-290
  describe 'title_browse_list' do
    before :all do
      setup_unit_test_collection_browse_lists
    end

    it 'returns list ordered by title__sort field' do
      titles = title_browse_list.keys
      titles[ 102 ].should == 'The Burma Campaign UK'
    end
  end

  describe '#load_browse_lists from specified browse lists file' do
    before :all do
      load_tiny_collection_browse_lists
    end

    after :all do
      setup_unit_test_collection_browse_lists
    end

    browse_categories.each { | browse_category, |
      it "loads #{ browse_category } browse list correctly" do
        browse_list = send( "#{ browse_category }_browse_list" )
        browse_list.length.should == expected_reloaded_browse_list_length
      end
    }

  end

end
