# -*- encoding : utf-8 -*-
require 'spec_helper'

include HRWA::CollectionBrowseLists

describe 'HRWA::CollectionBrowseLists' do
  
  # TODO: Checking for min lengths is a weak test.  Probably adding a test for presence of one 
  # known, stable value will be a big improvement.
  describe '#*_browse_list methods' do
    browse_categories = { 
                           'creator_name'          => 363,
                           'geographic_focus'      => 142,
                           'language'              => 54,
                           'organization_based_in' => 127,
                           'organization_type'     => 4,
                           'original_urls'         => 457,
                           'subject'               => 271,
                           'title'                 => 441,
                        }
      browse_categories.each { | browse_category, min |
        it "retrieves full #{ browse_category } browse list" do
          browse_list = HRWA::CollectionBrowseLists.send( "#{ browse_category }_browse_list" )
          browse_list.length.should >= min
        end
      }
  end

  describe '#browse_list' do
    it 'raises an error when passed an unknown browse category' do
      expect{ HRWA::CollectionBrowseLists.browse_list( 'xxx' ) }.to raise_error( ArgumentError )
    end
  end
  
end
