require 'spec_helper'
require 'debug'

def params
  return { 
              :action => 'index',
              :controller => 'catalog',
              :type => 'archive',
              :search_mode => 'advanced',
              :q_and => '',
              :q_phrase => '',
              :q_or => '',
              :q_exclude => '',
              :lim_domain => '',
              :lim_mimetype => '',
              :lim_language => '',
              :lim_geographic_focus => '',
              :lim_organization_based_in => '',
              :lim_organization_type => '',
              :lim_creator_name => '',
              :crawl_start_date => '2012-02-07',
              :crawl_end_date => '2012-02-09',
              :rows => '10',
              :sort => 'score desc',
              :host => 'harding.cul.columbia.edu',
              :path => '/solr-4/asf',
              :submit_search => 'Advanced Search',
         }
  end

  def params_list_expected_html
    return %q{<strong>action</strong> = index <br/><strong>controller</strong> = catalog <br/><strong>crawl_end_date</strong> = 2012-02-09 <br/><strong>crawl_start_date</strong> = 2012-02-07 <br/><strong>host</strong> = harding.cul.columbia.edu <br/><strong>path</strong> = /solr-4/asf <br/><strong>rows</strong> = 10 <br/><strong>search_mode</strong> = advanced <br/><strong>sort</strong> = score desc <br/><strong>submit_search</strong> = Advanced Search <br/><strong>type</strong> = archive <br/>}.html_safe
  end

describe 'hash_pp' do
  include Debug       
  it 'creates correct HTML given hash' do
    hash_pp( params ).should eq params_list_expected_html
  end
end


describe 'params_list' do
  include Debug       
  it 'creates correct HTML given list of params' do
    params_list.should eq params_list_expected_html
  end
end

