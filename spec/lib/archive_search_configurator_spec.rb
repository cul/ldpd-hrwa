require 'spec_helper'
require 'blacklight/configuration'
require 'archive_search_configurator'

describe 'ArchiveSearchConfigurator#config_proc' do   
    before( :all ) do 
      @blacklight_config = Blacklight::Configuration.new 
      @configurator      = ArchiveSearchConfigurator.new
      config_proc        = @configurator.config_proc
      @blacklight_config.configure &config_proc
    end
    
    it 'returns the correct partial name' do
      @configurator.result_partial.should == 'group'
    end
    
    it 'returns the correct result type' do
      @configurator.result_type.should == 'group'
    end

    it 'sets Blacklight::Configuration.default_solr_params correctly' do
      @blacklight_config.default_solr_params.should ==
        {
          :defType          => "dismax",
          :facet            => true,
          :'facet.field'    => [
                                'domain',
                                'geographic_focus__facet',
                                'organization_based_in__facet',
                                'organization_type__facet',
                                'language__facet',
                                'contentMetaLanguage',
                                'creator_name__facet',
                                'mimetype',
                                'dateOfCaptureYYYY',
                               ],
          :'facet.mincount' => 1,
          :'q.alt'          => "*:*",
          :qf               => ["contentTitle^1",
                                "contentBody^1",
                                "contentMetaDescription^1",
                                "contentMetaKeywords^1",
                                "contentMetaLanguage^1",
                                "contentBodyHeading1^1",
                                "contentBodyHeading2^1",
                                "contentBodyHeading3^1",
                                "contentBodyHeading4^1",
                                "contentBodyHeading5^1",
                                "contentBodyHeading6^1"],
          :rows             => 10,
        }  
    end
    
    it 'sets Blacklight::Configuration.facet_fields.* stuff correctly' do
      expected_facet_fields = {
        'domain'                       => { :label => 'Domain',                     :limit => 10 },
        'geographic_focus__facet'      => { :label => 'Organization/Site Geographic Focus',
                                                                                    :limit => 10 },
        'organization_based_in__facet' => { :label => 'Organization/Site Based In', :limit => 10 },
        'organization_type__facet'     => { :label => 'Organization Type',          :limit => 10 },
        'language__facet'              => { :label => 'Website Language',           :limit => 10 },
        'contentMetaLanguage'          => { :label => 'Language of page',           :limit => 10 },
        'creator_name__facet'          => { :label => 'Creator Name',               :limit => 10 },
        'mimetype'                     => { :label => 'File Type',                  :limit => 10 },
        'dateOfCaptureYYYY'            => { :label => 'Year of Capture',            :limit => 10 },        
      }
      
      expected_facet_fields.each { | name, expected |
        @blacklight_config.facet_fields[ name ].should_not be_nil
        @blacklight_config.facet_fields[ name ].label.should == expected[ :label ]
        @blacklight_config.facet_fields[ name ].limit.should == expected[ :limit ]
      }
    end
        
    it 'sets Blacklight::Configuration.index.* stuff correctly' do
      @blacklight_config.index.show_link.should           == 'contentTitle'
      @blacklight_config.index.record_display_type.should == ''
    end
    
    it 'sets Blacklight::Configuration.index_fields correctly' do
      expected_index_fields = {
        'contentTitle' => { :label => 'Title:', :field => 'contentTitle' },
        'contentBody'  => { :label => 'Body:',  :field => 'contentBody'  },
      }
      
      expected_index_fields.each { | name, expected |
        @blacklight_config.index_fields[ name ].should_not be_nil
        @blacklight_config.index_fields[ name ].label.should == expected[ :label ]
        @blacklight_config.index_fields[ name ].field.should == expected[ :field ]
      }
    end
    
    it 'sets Blacklight::Configuration.search_fields correctly' do
      @blacklight_config.search_fields.should be_empty
    end
         
    it 'sets Blacklight::Configuration.show_fields correctly' do
      expected_show_fields = {
        'contentTitle' => { :label => 'Title:' },
      }
      
      expected_show_fields.each { | name, expected |
        @blacklight_config.show_fields[ name ].should_not be_nil
        @blacklight_config.show_fields[ name ].label.should == expected[ :label ]
      }
    end
       
    it 'sets Blacklight::Configuration.sort_fields correctly' do
      expected_sort_fields = {
        'score desc, dateOfCaptureYYYYMMDD desc' => { :label => 'relevance' },
      }
      
      expected_sort_fields.each { | name, expected |
        @blacklight_config.sort_fields[ name ].should_not be_nil
        @blacklight_config.sort_fields[ name ].label.should == expected[ :label ]
      }
    end   
       
    it 'sets Blacklight::Configuration.spell_max correctly' do
      @blacklight_config.spell_max.should == 5
    end
    
    it 'sets Blacklight::Configuration.unique_key correctly' do
      @blacklight_config.unique_key.should == 'recordIdentifier'
    end
end

