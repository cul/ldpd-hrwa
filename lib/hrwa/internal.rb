require 'rsolr'
require 'spreadsheet'

module HRWA::Internal
  extend ActiveSupport::Concern

  def seed_list_excel_workbook
    solr_url = YAML.load_file( 'config/solr.yml' )[ Rails.env ][ 'fsf' ][ 'url' ]

    solr = RSolr.connect :url => solr_url

    response = solr.get 'select', :params => {
      :q    => '*:*',
      :fl   => 'original_urls, title, id',
      :rows => 99999,
    }

    status = response[ 'responseHeader' ][ 'status' ]

    if status != 0
        raise %q{Couldn't fetch seed list'}
    end

    Spreadsheet.client_encoding = 'UTF-8'
    workbook = Spreadsheet::Workbook.new
    sheet    = workbook.create_worksheet :name => 'Seed List'

    rows_to_write_to_sheet = { }
    response[ 'response' ][ 'docs' ].each_with_index { | doc, index |
      seed_urls = doc[ 'original_urls' ]
      seed_urls.each { | seed_url |
        rows_to_write_to_sheet[ seed_url ] = { }
        rows_to_write_to_sheet[ seed_url ][ 'id'    ] = doc[ 'id'    ]
        rows_to_write_to_sheet[ seed_url ][ 'title' ] = doc[ 'title' ]
      }
    }

    rows_to_write_to_sheet.keys.sort.each_with_index { | seed_url, index |
      sheet[ index, 0 ] = seed_url
      sheet[ index, 1 ] = rows_to_write_to_sheet[ seed_url ][ 'id'    ]
      sheet[ index, 2 ] = rows_to_write_to_sheet[ seed_url ][ 'title' ]
    }

    return workbook
  end

  def get_solr_host_from_url(search_type, localized_params = params)
    if(search_type == 'archive')
			if localized_params[:hrwa_host] == 'dev'
				'http://carter.cul.columbia.edu:8080/solr-4/asf'
			elsif localized_params[:hrwa_host] == 'test'
				'http://harding.cul.columbia.edu:8080/solr-4/asf'
			elsif localized_params[:hrwa_host] == 'prod'
				'http://machete.cul.columbia.edu:8181/solr-4/asf'
			end
    elsif(search_type == 'find_site')
			if localized_params[:hrwa_host] == 'dev'
				'http://carter.cul.columbia.edu:8080/solr-4/fsf'
			elsif localized_params[:hrwa_host] == 'test'
				'http://harding.cul.columbia.edu:8080/solr-4/fsf'
			elsif localized_params[:hrwa_host] == 'prod'
				'http://machete.cul.columbia.edu:8181/solr-4/fsf'
			end
    end
  end

end
