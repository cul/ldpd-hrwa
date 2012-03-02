# -*- encoding : utf-8 -*-
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
          option_list_none_selected = HRWA::FilterOptions.send( "#{ filter_option }_options" )
          option_list_none_selected.length.should >= min
          option_list_none_selected.has_value?( true ).should == false
        end
      }
  end
  
  describe '#option_list' do
    it 'raises an error when passed an unknown filter option' do
      expect{ HRWA::FilterOptions.option_list( 'xxx' ) }.to raise_error( ArgumentError )
    end
    
    filter_options = { 'bib_id'                => [ '4751601', '7033265', '8602843' ],
                       'creator_name'          => [ %q{Assot?s?iat?s?ii?a? korennykh malochislennykh narodov Severa, Sibiri i Dal'nego Vostoka Rossii?skoi? Federat?s?ii},
                                                    %q{Center for Economic and Social Rights},
                                                    %q{Defensori´a del Pueblo de la Repu´blica de Panama´},
                                                    %q{Empowerment and Rights Institute (China)},
                                                  ],
                       'domain'                => [ 'advocacyforum.org', 'drom-vidin.org' ],
                       'geographic_focus'      => [ 'Bosnia and Hercegovina', '[Global focus]', 'Yemen (Republic)', 'Puerto Rico', 'Morocco', ],
                       'language'              => [ 'Creoles and Pidgins, French-based (Other)', ],
                       'organization_based_in' => [ 'Eritrea', 'Kyrgyzstan', ],
                       'organization_type'     => [ 'Non-governmental organizations' ],
                     }
                     
    filter_options.each { | option, selected_values | 
      it "sets selection statuses correctly for #{ option } option" do
        option_list_selected = HRWA::FilterOptions.option_list( option, selected_values )
        selected_values.each { | value |
          option_list_selected[ value ].should == true
        }
        # Only selected values should be true in the option hash
        option_list_selected.values.count( true ).should == selected_values.length
      end
    }
  end
  
end
