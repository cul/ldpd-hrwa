require 'spec_helper'
require 'cgi'

include HRWA::CatalogHelperBehavior

describe 'exclude_domain_from_hits_link' do
  before :all do
    @domain = 'www.hrw.org'
    @params_unsorted = { :search_type => 'archive', :search_mode => 'advanced', :q => 'women', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search' }
    params_expected_in_url = @params_unsorted.merge( :'excl_domain' => @domain )
    
    # The method being tested uses sorted params
    @expected_link_tag = %Q{<a href="/search?}
    params_expected_in_url.keys.sort.each { | key |
      name  = CGI::escape( key.to_s )
      value = CGI::escape( params_expected_in_url[ key ] )
      @expected_link_tag << "#{ name }=#{ value }&amp;"
    }
    @expected_link_tag.sub!( /&amp;$/, '' )
    @expected_link_tag << %Q{">Exclude &quot;#{ @domain }&quot; from hits</a>}
  end
  
  it 'creates correct link' do
    link_tag        = exclude_domain_from_hits_link( @params_unsorted, @domain )
    link_tag.should == @expected_link_tag
  end
  
  it 'won\'t create redundant name/value pair in URL' do
    params_with_domain_facet_pair_already_present =
      @params_unsorted.merge( :'excl_domain' => @domain )    
    link_tag = exclude_domain_from_hits_link( params_with_domain_facet_pair_already_present,
                                              @domain )
    link_tag.should == @expected_link_tag
  end
end

describe 'see_all_hits_from_domain_link' do
  before :all do
    @domain = 'www.hrw.org'
    @params_unsorted = { :search_type => 'archive', :search_mode => 'advanced', :q => 'women', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search' }
    params_expected_in_url = @params_unsorted.merge( :'f[domain][]' => @domain )
    
    # The method being tested uses sorted params
    @expected_link_tag = %Q{<a href="/search?}
    params_expected_in_url.keys.sort.each { | key |
      name  = CGI::escape( key.to_s )
      value = CGI::escape( params_expected_in_url[ key ] )
      @expected_link_tag << "#{ name }=#{ value }&amp;"
    }
    @expected_link_tag.sub!( /&amp;$/, '' )
    @expected_link_tag << %Q{">See all hits from &quot;#{ @domain }&quot;</a>}
  end
  
  it 'creates correct link' do
    link_tag        = see_all_hits_from_domain_link( @params_unsorted, @domain )
    link_tag.should == @expected_link_tag
  end
  
  it 'won\'t create redundant name/value in URL' do
    params_with_domain_facet_pair_already_present =
      @params_unsorted.merge( :'f[domain][]' => @domain )    
    link_tag = see_all_hits_from_domain_link( params_with_domain_facet_pair_already_present,
                                              @domain )
    link_tag.should == @expected_link_tag
  end
end

# TODO: Find out way to change params hash inside rewritten_request_url_overwrite_params
# describe 'rewritten_request_url_overwrite_params' do
  # it 'adds a facet param to the existing path' do
    # params = { :search_type => 'archive', :search_mode => 'advanced', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search', }
#     
    # new_url = rewritten_request_url_overwrite_params( { :'f[domain][]' => 'www.hrw.org' } )
    # new_url.should == 'http://bronte.cul.columbia.edu:3020/search?search_type=archive&search_mode=advanced&q_and=women&q_phrase=&q_or=&q_exclude=&lim_domain=&lim_mimetype=&lim_language=&lim_geographic_focus=&lim_organization_based_in=&lim_organization_type=&lim_creator_name=&crawl_start_date=&crawl_end_date=&rows=10&sort=score%20desc&solr_host=harding.cul.columbia.edu&solr_core_path=/solr-4/asf&submit_search=Advanced%20Search&controller=catalog&action=index&q=+women&f[domain][]=www.hrw.org'
  # end
# end
