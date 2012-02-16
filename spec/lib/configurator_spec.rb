require 'spec_helper'
require 'configurator'

describe 'Configurator' do   
  it 'constructor returns an ArchiveSearchConfigurator when passed :archive' do
      Configurator.new( :archive ).instance_variable_get( :@configurator )
        .should be_an_instance_of( ArchiveSearchConfigurator )
  end
    
  it 'constructor returns a FindSiteSearchConfigurator when passed :find_site' do
      Configurator.new( :find_site ).instance_variable_get( :@configurator )
        .should be_an_instance_of( FindSiteSearchConfigurator )
  end
end

