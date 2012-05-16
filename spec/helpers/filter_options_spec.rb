# -*- encoding : utf-8 -*-
require 'spec_helper'

include HRWA::FilterOptions

describe 'HRWA::FilterOptions' do
  
  # TODO: Checking for min lengths is a weak test.  Probably adding a test for presence of one 
  # known, stable value will be a big improvement.
  describe '#*_options methods' do
    filter_options = {
                       'creator_name'          => 363,
                       'domain'                => 371,
                       'geographic_focus'      => 142,
                       'language'              => 54,
                       'organization_based_in' => 127,
                       'organization_type'     => 4,
                       'original_urls'         => 457,
                       'subject'               => 271,
                       'title'                 => 441,
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
  end
  
  describe '#*_options methods' do
    
    filter_options = {
                       'creator_name'          => [ %q{Assot︠s︡iat︠s︡ii︠a︡ korennykh malochislennykh narodov Severa, Sibiri i Dalʹnego Vostoka Rossiĭskoĭ Federat︠s︡ii},
                                                    %q{Center for Economic and Social Rights},
                                                    %q{Defensoría del Pueblo de la República de Panamá},
                                                    %q{Empowerment and Rights Institute (China)},
                                                  ],
                       'domain'                => [ 'advocacyforum.org', 'drom-vidin.org' ],
                       'geographic_focus'      => [ 'Bosnia and Hercegovina', '[Global focus]', 'Yemen (Republic)', 'Puerto Rico', 'Morocco', ],
                       'language'              => [ 'Creoles and Pidgins, French-based (Other)', ],
                       'organization_based_in' => [ 'Eritrea', 'Kyrgyzstan', ],
                       'organization_type'     => [ 'Non-governmental organizations' ],
                       'original_urls'         => [ 'http://hoodonline.org/'],
                       'subject'               => [ 'Women in Islam', 'Civil rights' ],
                       'title'                 => [ 'CONECTAS Direitos Humanos', 'Amman Center for Human Rights Studies']
                     }

    filter_options.each { | option, selected_values |
      method_name = "#{ option }_options"
      it ": #{ method_name }( opts ) sets statuses correctly" do
        option_list_selected = HRWA::FilterOptions.send( method_name, :selected => selected_values )
        selected_values.each { | value |
          option_list_selected[ value ].should == true
        }

        # Only selected values should be true in the option hash
        option_list_selected.values.count( true ).should == selected_values.length
      end
    }
  end

end
