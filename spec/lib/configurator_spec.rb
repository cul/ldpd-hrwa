require 'spec_helper'

describe 'HRWA::Configurator' do   
  it 'constructor returns an HRWA::ArchiveSearchConfigurator when passed :archive' do
      HRWA::Configurator.new( :archive ).instance_variable_get( :@configurator )
        .should be_an_instance_of( HRWA::ArchiveSearchConfigurator )
  end
    
  it 'constructor returns a FindSiteSearchConfigurator when passed :find_site' do
      HRWA::Configurator.new( :find_site ).instance_variable_get( :@configurator )
        .should be_an_instance_of( HRWA::FindSiteSearchConfigurator )
  end
end

