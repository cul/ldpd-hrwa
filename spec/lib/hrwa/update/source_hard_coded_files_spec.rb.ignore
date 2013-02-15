require 'spec_helper'

require 'hrwa/update/source_hard_coded_files.rb'
describe 'hard coded options and browse lists file updater' do
  before :all do
    @filter_options_expected_file = 'spec/lib/fixtures/filter_options_source_hardcoded.rb'
    @filter_options_got_file      = 'spec/lib/fixtures/filter_options_source_hardcoded_got.rb'

    @collection_browse_lists_expected_file = 'spec/lib/fixtures/collection_browse_lists_source_hardcoded.rb'
    @collection_browse_lists_got_file      = 'spec/lib/fixtures/collection_browse_lists_source_hardcoded_got.rb'

    solr_url = YAML.load_file( 'config/solr.yml' )[ Rails.env ][ 'fsf' ][ 'url' ]

    FileUtils.rm [ @collection_browse_lists_got_file, @filter_options_got_file ], :force => true

    @sourceHardCodedFilesUpdater = Hrwa::Update::SourceHardCodedFiles.new( @collection_browse_lists_got_file,
                           @filter_options_got_file,
                           solr_url,
                         )
  end

  it 'updates collection browse lists file' do
    begin
      @sourceHardCodedFilesUpdater.update_rails_file( :browse_lists )
    rescue UpdateException => e
      puts "Update of rails app aborted with error: #{ e }"
    end

    FileUtils.compare_file( @collection_browse_lists_got_file, @collection_browse_lists_expected_file ).should == true
  end

  it 'updates filter options file' do
    begin
      @sourceHardCodedFilesUpdater.update_rails_file( :filter_options )
    rescue UpdateException => e
      puts "Update of rails app aborted with error: #{ e }"
    end

    FileUtils.compare_file( @filter_options_got_file, @filter_options_expected_file ).should == true
  end

  it 'raises an ArgumentError when a invalid component is passed to update_rails_file()' do
    begin
      @sourceHardCodedFilesUpdater.update_rails_file( :invalid_component )
    rescue Exception => e
    end
    e.class.should == ArgumentError
  end
end
