require 'spec_helper'
require 'blacklight/configuration'

describe 'Hrwa::SiteDetailConfigurator' do
  before ( :all ) do
    @configurator = Hrwa::SiteDetailConfigurator.new
  end

  it 'returns the correct partial name' do
    @configurator.result_partial.should == 'document'
  end

  it 'returns the correct result type' do
    @configurator.result_type.should == 'document'
  end

  it 'returns the correct name' do
    @configurator.name.should == 'site_detail'
  end

  context '#config_proc' do
    before( :all ) do
      @blacklight_config = Blacklight::Configuration.new
      config_proc        = @configurator.config_proc
      @blacklight_config.configure &config_proc
    end

    it 'sets Blacklight::Configuration.default_solr_params correctly' do
      @blacklight_config.default_solr_params.should ==
        {
            :defType          => "dismax",
            :facet            => true,
            :'facet.mincount' => 1,
            :hl               => true,
            :'hl.fragsize'    => 400,
            :'hl.fl'          => [
                                  "alternate_title",
                                  "creator_name",
                                  "geographic_focus",
                                  "language",
                                  "organization_based_in",
                                  "original_urls",
                                  "summary",
                                  "title",
                                 ],
            :'hl.usePhraseHighlighter' => true,
            :'hl.simple.pre'  => '<code>',
            :'hl.simple.post' => '</code>',
            :'q.alt'          => "*:*",
            :qf               => [
                                  "alternate_title^1",
                                  "creator_name^1",
                                  "geographic_focus^1",
                                  "language^1",
                                  "organization_based_in^1",
                                  "original_urls^1",
                                  "summary^1",
                                  "title^1",
                                  ],
            :rows             => 10,
            :'facet.field'    => [
                                  "geographic_focus__facet",
                                  "language__facet",
                                  "organization_based_in__facet",
                                  "organization_type__facet",
                                  "subject__facet"
                                 ],
        }
    end

    it 'sets Blacklight::Configuration.facet_fields.* stuff correctly' do

      expected_facet_fields = {

        'organization_type__facet'      => { :label => 'Organization Type',     :limit => 5 },

        'subject__facet'                => { :label => 'Subject',               :limit => 5 },

        'geographic_focus__facet'       => { :label => 'Geographic Focus',      :limit => 5 },

        'organization_based_in__facet'  => { :label => 'Organization Based In', :limit => 5 },

        'language__facet'               => { :label => 'Language',              :limit => 5 },
      }

      expected_facet_fields.each { | name, expected |
        @blacklight_config.facet_fields[ name ].should_not be_nil
        @blacklight_config.facet_fields[ name ].label.should == expected[ :label ]
        @blacklight_config.facet_fields[ name ].limit.should == expected[ :limit ]
      }
    end

    it 'sets Blacklight::Configuration.index.* stuff correctly' do
      @blacklight_config.index.show_link.should           == 'title'
      @blacklight_config.index.record_display_type.should == ''
    end

    it 'sets Blacklight::Configuration.index_fields correctly' do
        @blacklight_config.index_fields.should be_empty
    end

    it 'sets Blacklight::Configuration.search_fields correctly' do
      @blacklight_config.search_fields.should be_empty
    end

    it 'sets Blacklight::Configuration.show_fields correctly' do
        @blacklight_config.show_fields.should be_empty
    end

    it 'sets Blacklight::Configuration.sort_fields correctly' do
      expected_sort_fields = {
        'score desc' => { :label => 'relevance' },
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
      @blacklight_config.unique_key.should == 'id'
    end

    it '#post_blacklight_processing_required? returns true' do
      @configurator.post_blacklight_processing_required?.should == false
    end

    # TODO: add highlight specs
  end

  describe '#configure_facet_action' do
    before :all do
      @blacklight_config  = Blacklight::Configuration.new
      config_proc        = @configurator.config_proc
      @blacklight_config.configure &config_proc
    end

    it 'removed the group params from the Blacklight configuration default_solr_params hash' do
      @configurator.configure_facet_action( @blacklight_config )
      @blacklight_config.default_solr_params.select { | k, v | k.to_s.start_with?( 'group' ) }.
        should be_empty
    end
  end

  describe '#solr_url' do

    solr_yml = YAML.load_file( 'config/solr.yml' )

    before :each do
        @configurator.class.reset_solr_config
    end

    after :each do
        @configurator.class.reset_solr_config
    end

    it 'returns correct URL for environment "development"' do
      @configurator.class.solr_url( 'development' ).should == solr_yml['development']['site_detail']['url']
    end

    it 'returns correct URL for environment "test"' do
      # Not necessary to explicitly pass in environment for test, obviously
      @configurator.class.solr_url().should == solr_yml['test']['site_detail']['url']
    end

    it 'returns correct URL for environment "hrwa_dev"' do
      @configurator.class.solr_url( 'hrwa_dev' ).should == solr_yml['hrwa_dev']['site_detail']['url']
    end

    it 'returns correct URL for environment "hrwa_test"' do
      @configurator.class.solr_url( 'hrwa_test' ).should == solr_yml['hrwa_test']['site_detail']['url']
    end

    it 'returns correct URL for environment "hrwa_staging"' do
      @configurator.class.solr_url( 'hrwa_staging' ).should == solr_yml['hrwa_staging']['site_detail']['url']
    end

    it 'returns correct URL for environment "hrwa_prod"' do
      @configurator.class.solr_url( 'hrwa_prod' ).should == solr_yml['hrwa_prod']['site_detail']['url']
    end
  end

end
