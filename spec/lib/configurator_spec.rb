require 'spec_helper'
require 'blacklight/configuration'
require 'configurator'

describe 'Configurator' do   
  
  describe 'constructor' do
    it 'returns an ArchiveSearchConfigurator when passed :archive' do
      Configurator.new( :archive ).instance_variable_get( :@configurator )
        .should be_an_instance_of( ArchiveSearchConfigurator )
    end
    
    it 'returns a FindSiteSearchConfigurator when passed :find_site' do
      Configurator.new( :find_site ).instance_variable_get( :@configurator )
        .should be_an_instance_of( FindSiteSearchConfigurator )
    end
  end
    
  describe '#config_proc for archive search' do
    before( :all ) do 
      @blacklight_config = Blacklight::Configuration.new
      config_proc = Configurator.new( :archive ).config_proc
      @blacklight_config.configure &config_proc
    end

    it 'sets default_solr_params correctly' do
      false
    end  
  end
end

