require 'spec_helper'

describe 'Hrwa::Configurator' do
  it 'constructor returns an Hrwa::ArchiveSearchConfigurator when passed :archive' do
      Hrwa::Configurator.new( :archive ).instance_variable_get( :@configurator )
        .should be_an_instance_of( Hrwa::ArchiveSearchConfigurator )
  end

  it 'constructor returns a FindSiteSearchConfigurator when passed :find_site' do
      Hrwa::Configurator.new( :find_site ).instance_variable_get( :@configurator )
        .should be_an_instance_of( Hrwa::FindSiteSearchConfigurator )
  end
end
