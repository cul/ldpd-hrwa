# -*- encoding : utf-8 -*-
require 'spec_helper'

require 'spreadsheet'

class MockInternalController
  include HRWA::Internal
end

describe 'HRWA::Internal' do     
  it '#seed_list_excel_workbook' do
    expected_rows = spreadsheet_to_rows( expected_seed_list_workbook.worksheet 'Seed List' )
    got_rows      = spreadsheet_to_rows(
      MockInternalController.new.seed_list_excel_workbook.worksheet 'Seed List'
    )
    got_rows.should == expected_rows
  end
end

def spreadsheet_to_rows( spreadsheet )
  rows = []
  spreadsheet.each_with_index { | sheet_row, index |
    rows[ index ] = sheet_row.inject( :+ )
  }
  return rows
end

def expected_seed_list_workbook
  # The was created by dumping the workbook created by the version of this method
  # in commit 1e1eb99aaa84ec29b6a4b60dad229f90763d43be  
  workbook = Marshal.load( File.open( 'spec/lib/fixtures/expected_seed_list_workbook.dump' ) )
  
  return workbook
end
