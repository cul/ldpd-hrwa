require 'rsolr'
require 'spreadsheet'

module HRWA::Internal
  extend ActiveSupport::Concern
  
  def site_list_excel_workbook
    solr_url = YAML.load_file( 'config/solr.yml' )[ Rails.env ][ 'fsf' ][ 'url' ]
  
    solr = RSolr.connect :url => solr_url
    
    response = solr.get 'select', :params => {
      :q    => '*:*',
      :fl   => 'title, id',
      :sort => 'title__facet asc',
      :rows => 99999,
    }     
    
    status = response[ 'responseHeader' ][ 'status' ]
    
    if status != 0
        raise 
    end
    
    Spreadsheet.client_encoding = 'UTF-8' 
    workbook = Spreadsheet::Workbook.new
    sheet    = workbook.create_worksheet :name => 'Site ID List'
    
    response[ 'response' ][ 'docs' ].each_with_index { | doc, index | 
      sheet[ index, 0 ] = doc[ 'title' ]
      sheet[ index, 1 ] = doc[ 'id'    ]
    }    
    
    return workbook
  end
  
end