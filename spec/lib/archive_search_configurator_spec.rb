require 'spec_helper'
require 'blacklight/configuration'
require 'archive_search_configurator'

describe 'ArchiveSearchConfigurator#config_proc' do   
    before( :all ) do 
      @blacklight_config = Blacklight::Configuration.new
      config_proc = ArchiveSearchConfigurator.new.config_proc
      @blacklight_config.configure &config_proc
    end

    it 'sets default_solr_params correctly' do
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
end

