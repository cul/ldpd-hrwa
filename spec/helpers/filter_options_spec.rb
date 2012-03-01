require 'spec_helper'

include HRWA::FilterOptions

describe 'HRWA::FilterOptions' do
  
  describe '#*_options methods' do
    filter_options = { 'bib_id'                => 360,
                       'creator_name'          => 363,
                       'domain'                => 371,
                       'geographic_focus'      => 142,
                       'language'              => 54,
                       'organization_based_in' => 127,
                       'organization_type'     => 4,
                     }
      filter_options.each { | filter_option, min |
        it "retrieves full list of #{ filter_option } unselected options when passed nil (no array of selected values)" do
          options_full_list = HRWA::FilterOptions.send( "#{ filter_option }_options" )
          options_full_list.length.should >= min
          options_full_list.has_value?( true ).should == false
        end
      }
  end
  
  describe '#option_list' do
    it 'raises an error when passed an unknown filter option' do
      expect{ HRWA::FilterOptions.option_list( 'xxx' ) }.to raise_error( ArgumentError )
    end
  end
  
end
