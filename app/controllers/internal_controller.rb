require 'blacklight/catalog'
require 'pp'

class InternalController < ApplicationController
  include HRWA::Internal
  
  SITE_ID_FILE = '/tmp/hrwa_site_id_list.xls'

  def seed_list
    workbook = seed_list_excel_workbook
    workbook.write SITE_ID_FILE 
    send_file SITE_ID_FILE, :type => "application/vnd.ms-excel"
  end  

end
