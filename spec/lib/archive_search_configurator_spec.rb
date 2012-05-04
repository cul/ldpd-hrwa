require 'spec_helper'
require 'blacklight/configuration'

describe 'HRWA::ArchiveSearchConfigurator' do
  before ( :all ) do
    @advanced_search_q_and_women_params = { :search_type => 'archive', :search_mode => 'advanced', :q => 'women', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :capture_start_date => '', :capture_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search' }

    @configurator = HRWA::ArchiveSearchConfigurator.new
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
          :'facet.field'    => [
                                'dateOfCaptureYYYY',
                                'domain',
                                'geographic_focus__facet',
                                'organization_based_in__facet',
                                'organization_type__facet',
                                'language__facet',
                                'creator_name__facet',
                                'mimetype',
                               ],
          :'facet.mincount' => 1,
          :group            => true,
          :'group.field'    => 'originalUrl',
          :'group.limit'    => 10,
          :hl               => true,
          :'hl.fragsize'    => 1000,
          :'hl.fl'          => [
                               'contentBody',
                               'contentTitle',
                               'originalUrl',
                               ],
          :'hl.usePhraseHighlighter' => true,
          :'hl.simple.pre'  => '<code>',
          :'hl.simple.post' => '</code>',
          :'q.alt'          => "*:*",
          :qf               => [
                                'contentBody^1',
                                'contentTitle^1',
                                'originalUrl^1',
                               ],
          :rows             => 10,
        }
    end

    it 'sets Blacklight::Configuration.facet_fields.* stuff correctly' do
      expected_facet_fields = {
        'dateOfCaptureYYYY'            => { :label => 'Date Of Capture',            :limit => 5 },
        'domain'                       => { :label => 'Domain',                     :limit => 5 },
        'geographic_focus__facet'      => { :label => 'Geographic Focus',           :limit => 5 },
        'organization_based_in__facet' => { :label => 'Organization Based In',      :limit => 5 },
        'organization_type__facet'     => { :label => 'Organization Type',          :limit => 5 },
        'language__facet'              => { :label => 'Website Language',           :limit => 5 },
        'creator_name__facet'          => { :label => 'Creator',                    :limit => 5 },
        'mimetype'                     => { :label => 'File Type',                  :limit => 5 },
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
      @blacklight_config.unique_key.should == 'recordIdentifier'
    end

    it '#post_blacklight_processing_required? returns true' do
      @configurator.post_blacklight_processing_required?.should == true
    end

    it '#post_blacklight_processing modifies result_list correctly' do
      raw_response         = create_mock_raw_response
      expected_result_list = raw_response[ 'grouped' ][ 'originalUrl' ][ 'groups' ]

      solr_response = create_mock_rsolr_ext_response
      result_list   = [ "doesn't matter what's in here -- should never see this" ]
      solr_response, result_list = @configurator.post_blacklight_processing( solr_response, result_list )
      result_list.should == expected_result_list
    end

    # TODO: add group and highlight specs
  end


  describe '#add_capture_date_range_fq_to_solr' do
    before :each do
      @extra_controller_params = {}
      @extra_controller_params[ :fq ] = nil
    end

    blank_inputs = [ nil, '' ]

    # Test all permutations of completely blank/nil input
    blank_inputs.each { | start_date |
      [ nil, '' ].each{ | end_date |
        it "does not add :fq for start = #{ start_date.to_s } and end = #{ end_date.to_s }" do
          @configurator.add_capture_date_range_fq_to_solr(
            @extra_controller_params,
            { :capture_start_date => start_date, :capture_end_date => end_date }
          )
          @extra_controller_params[ :fq ].should be_nil
        end
      }
    }

    blank_inputs.each { | end_date |
      it "adds closed-start, open-end :fq date range with non-blank start and end = #{ end_date.to_s }" do
        @configurator.add_capture_date_range_fq_to_solr(
          @extra_controller_params,
          { :capture_start_date => '200801', :capture_end_date => end_date }
        )
        @extra_controller_params[ :fq ].should == [ 'dateOfCaptureYYYYMM:[ 200801 TO * ]' ]
      end
    }

    blank_inputs.each { | start_date |
      it "adds and open-start, closed-end date range with start = #{ start_date.to_s } and non-blank end" do
        @configurator.add_capture_date_range_fq_to_solr(
          @extra_controller_params,
          { :capture_start_date => start_date, :capture_end_date => '200801' }
        )
        @extra_controller_params[ :fq ].should == [ 'dateOfCaptureYYYYMM:[ * TO 200801 ]' ]
      end
    }

    it 'adds a closed-start, closed-end :fq date range with non-blank start and end inputs' do
      @configurator.add_capture_date_range_fq_to_solr(
        @extra_controller_params,
        { :capture_start_date => '200801', :capture_end_date => '201201' }
      )
      @extra_controller_params[ :fq ].should == [ 'dateOfCaptureYYYYMM:[ 200801 TO 201201 ]' ]
    end
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

  describe '#process_search_request - domain exclusion' do
    before :each do
      @params = @advanced_search_q_and_women_params.dup
    end

    domains_to_exclude = [
                           [ 'www.hrw.org', 'wayback.archive-it.org', 'amnesty.org' ],
                           [ 'advocacyforum.org' ],
                           [ ],
                         ]
    domains_to_exclude.each { | domains |
      it "creates correct fq SOLR params for excl_domain[] = #{ domains }" do
        @params.merge!( { :'excl_domain' => domains } )
        extra_controller_params = {}
        @configurator.process_search_request( extra_controller_params, @params )
        extra_controller_params[ :fq ].should == domains.map { | domain | "-domain:#{ domain }" }
      end
    }

  end

  describe '#result_partial' do
    it 'returns the correct partial name' do
      @configurator.result_partial.should == 'group'
    end
  end

  describe '#result_type' do
    it 'returns the correct result type' do
      @configurator.result_type.should == 'group'
    end
  end

  describe '#set_solr_field_boost_levels' do
    before :all do
      @default_qf   = [ 'contentTitle^1', 'contentBody^1', 'originalUrl^1' ]
      @valid_params = [ 'contentTitle^3', 'contentBody^2', 'originalUrl^4' ]
      @bad_params   = [ 'title^5', 'body^3' ]
    end

    before :each do
      @params = @advanced_search_q_and_women_params.dup
    end

    it 'sets full field set boosts correctly' do
      @params[ :field ] = @valid_params
      extra_controller_params = { :qf => @default_qf }
      @configurator.set_solr_field_boost_levels( extra_controller_params, @params )
      extra_controller_params.should == { :qf => @valid_params }
    end

    it 'sets partial field set boosts correctly' do
      @partial_params = @valid_params.slice( 0..@valid_params.length - 2 )
      @params[ :field ] = @partial_params
      extra_controller_params = { :qf => @default_qf }
      @configurator.set_solr_field_boost_levels( extra_controller_params, @params )
      extra_controller_params.should == { :qf => @partial_params }
    end

    it 'does nothing and exits when no field params present' do
      extra_controller_params = { :qf => @default_qf }
      @configurator.set_solr_field_boost_levels( extra_controller_params, @params )
      extra_controller_params.should == { :qf => @default_qf }
    end

    describe 'argument validation' do
      # Test bad boost values
      [ '-12', 'orange', '0' ].each { | value |
        it "raises ArgumentError for bad boost value #{ value }" do
          expect{
            @configurator.set_solr_field_boost_levels(
              {},
              { :field => [ "contentTitle^#{ value }" ] }
            )
          }.to raise_error( ArgumentError )
        end
      }
    end

    it 'ignores invalid field arguments' do
      extra_controller_params = { :qf => @default_qf }
      @params.merge!( :field => @valid_params | @bad_params )
      @configurator.set_solr_field_boost_levels( extra_controller_params, @params )
      extra_controller_params.should == { :qf => @valid_params }
    end
  end

  describe '#solr_url' do

    solr_yml = YAML.load_file( 'config/solr.yml' )

    it 'returns correct URL for environment "development"' do
      @configurator.solr_url( 'development' ).should == solr_yml['development']['asf']['url']
    end

    it 'returns correct URL for environment "test"' do
      # Not necessary to explicitly pass in environment for test, obviously
      @configurator.solr_url().should == solr_yml['test']['asf']['url']
    end

    it 'returns correct URL for environment "hrwa_dev"' do
      @configurator.solr_url( 'hrwa_dev' ).should == solr_yml['hrwa_dev']['asf']['url']
    end

    it 'returns correct URL for environment "hrwa_test"' do
      @configurator.solr_url( 'hrwa_test' ).should == solr_yml['hrwa_test']['asf']['url']
    end

    it 'returns correct URL for environment "hrwa_staging"' do
      @configurator.solr_url( 'hrwa_staging' ).should == solr_yml['hrwa_staging']['asf']['url']
    end

    it 'returns correct URL for environment "hrwa_prod"' do
      @configurator.solr_url( 'hrwa_prod' ).should == solr_yml['hrwa_prod']['asf']['url']
    end
  end

end
