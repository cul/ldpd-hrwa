require 'spec_helper'
require 'cgi'

include HRWA::CatalogHelperBehavior

describe 'exclude_domain_from_hits_link' do
  before :each do
    @domain1 = 'www.hrw.org'
    @domain2 = 'amnesty.org'
    @params_unsorted = { :search_type => 'archive', :search_mode => 'advanced', :q => 'women', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search' }

    @params_expected_in_url1 = @params_unsorted.merge( :'excl_domain[]' => [ @domain1 ] )
    @params_expected_in_url2 = @params_unsorted.merge( :'excl_domain[]' => [ @domain1, @domain2 ] )

    # NOTE: The method being tested uses sorted params

    # Link for one domain exclusion added
    @expected_link_tag1 = %Q{<a href="/search?}
    @params_expected_in_url1.keys.sort.each { | key |
      name  = CGI::escape( key.to_s )
      if @params_expected_in_url1[ key ].respond_to?( :each )
        @params_expected_in_url1[ key ].each { | value |
          @expected_link_tag1 << "#{ name }=#{ CGI::escape( value ) }&amp;"
        }
      else
        value = CGI::escape( @params_expected_in_url1[ key ] )
        @expected_link_tag1 << "#{ name }=#{ value }&amp;"
      end
    }
    @expected_link_tag1.sub!( /&amp;$/, '' )
    @expected_link_tag1 << %Q{">Exclude this domain from results</a>}


    # Link for an additional domain exclusion added
    @expected_link_tag2 = %Q{<a href="/search?}
    @params_expected_in_url2.keys.sort.each { | key |
      name  = CGI::escape( key.to_s )
      if @params_expected_in_url2[ key ].respond_to?( :each )
        @params_expected_in_url2[ key ].each { | value |
          @expected_link_tag2 << "#{ name }=#{ CGI::escape( value ) }&amp;"
        }
      else
        value = CGI::escape( @params_expected_in_url2[ key ] )
        @expected_link_tag2 << "#{ name }=#{ value }&amp;"
      end
    }
    @expected_link_tag2.sub!( /&amp;$/, '' )
    @expected_link_tag2 << %Q{">Exclude this domain from results</a>}
  end

  it 'creates correct link if there are no domains already excluded' do
    link_tag        = exclude_domain_from_hits_link( @params_unsorted, @domain1 )
    link_tag.should == @expected_link_tag1
  end

  it 'creates correct link if one domain is already excluded' do
    link_tag        = exclude_domain_from_hits_link( @params_expected_in_url1, @domain2 )
    link_tag.should == @expected_link_tag2
  end

  it 'returns the current URL when attempting to exclude a domain that is already being excluded' do
    link_tag = exclude_domain_from_hits_link( @params_expected_in_url1, @domain1 )
    link_tag = @expected_link_tag1
  end
end

describe 'debug_link' do
  it 'creates debug_off_link when debug is already set' do
    debug_url_params = { :search_type => 'archive', :search_mode => 'advanced', :q => 'women', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search', :hrwa_debug => nil, }

    link_tag = debug_link( debug_url_params )

    link_tag.should == %q{<a href="/search?crawl_end_date=&amp;crawl_start_date=&amp;lim_creator_name=&amp;lim_domain=&amp;lim_geographic_focus=&amp;lim_language=&amp;lim_mimetype=&amp;lim_organization_based_in=&amp;lim_organization_type=&amp;q=women&amp;q_and=women&amp;q_exclude=&amp;q_or=&amp;q_phrase=&amp;rows=10&amp;search_mode=advanced&amp;search_type=archive&amp;solr_core_path=%252Fsolr-4%252Fasf&amp;solr_host=harding.cul.columbia.edu&amp;sort=score%2Bdesc&amp;submit_search=Advanced%2BSearch">Turn debug off</a>}
  end

  it 'creates debug_on_link if debug is not already set' do
    url_params = { :search_type => 'archive', :search_mode => 'advanced', :q => 'women', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search', }

   link_tag = debug_link( url_params )

   link_tag.should == %q{<a href="/search?crawl_end_date=&amp;crawl_start_date=&amp;hrwa_debug=true&amp;lim_creator_name=&amp;lim_domain=&amp;lim_geographic_focus=&amp;lim_language=&amp;lim_mimetype=&amp;lim_organization_based_in=&amp;lim_organization_type=&amp;q=women&amp;q_and=women&amp;q_exclude=&amp;q_or=&amp;q_phrase=&amp;rows=10&amp;search_mode=advanced&amp;search_type=archive&amp;solr_core_path=%252Fsolr-4%252Fasf&amp;solr_host=harding.cul.columbia.edu&amp;sort=score%2Bdesc&amp;submit_search=Advanced%2BSearch">Turn debug on</a>}
  end
end

describe 'debug_off_link' do
  it 'creates correct exit debug mode link' do
    @debug_url_params = { :search_type => 'archive', :search_mode => 'advanced', :q => 'women', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search', :hrwa_debug => nil, }

   link_tag = debug_off_link( @debug_url_params )

   link_tag.should == %q{<a href="/search?crawl_end_date=&amp;crawl_start_date=&amp;lim_creator_name=&amp;lim_domain=&amp;lim_geographic_focus=&amp;lim_language=&amp;lim_mimetype=&amp;lim_organization_based_in=&amp;lim_organization_type=&amp;q=women&amp;q_and=women&amp;q_exclude=&amp;q_or=&amp;q_phrase=&amp;rows=10&amp;search_mode=advanced&amp;search_type=archive&amp;solr_core_path=%252Fsolr-4%252Fasf&amp;solr_host=harding.cul.columbia.edu&amp;sort=score%2Bdesc&amp;submit_search=Advanced%2BSearch">Turn debug off</a>}
  end
end

describe 'debug_on_link' do
  it 'creates correct exit debug mode link' do
    @url_params = { :search_type => 'archive', :search_mode => 'advanced', :q => 'women', :q_and => 'women', :q_phrase => '', :q_or => '', :q_exclude => '', :lim_domain => '', :lim_mimetype => '', :lim_language => '', :lim_geographic_focus => '', :lim_organization_based_in => '', :lim_organization_type => '', :lim_creator_name => '', :crawl_start_date => '', :crawl_end_date => '', :rows => '10', :sort => 'score+desc', :solr_host => 'harding.cul.columbia.edu', :solr_core_path => '%2Fsolr-4%2Fasf', :submit_search => 'Advanced+Search', }

   link_tag = debug_on_link( @url_params )

   link_tag.should == %q{<a href="/search?crawl_end_date=&amp;crawl_start_date=&amp;hrwa_debug=true&amp;lim_creator_name=&amp;lim_domain=&amp;lim_geographic_focus=&amp;lim_language=&amp;lim_mimetype=&amp;lim_organization_based_in=&amp;lim_organization_type=&amp;q=women&amp;q_and=women&amp;q_exclude=&amp;q_or=&amp;q_phrase=&amp;rows=10&amp;search_mode=advanced&amp;search_type=archive&amp;solr_core_path=%252Fsolr-4%252Fasf&amp;solr_host=harding.cul.columbia.edu&amp;sort=score%2Bdesc&amp;submit_search=Advanced%2BSearch">Turn debug on</a>}
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
    @expected_link_tag << %Q{">See all results from &quot;#{ @domain }&quot;</a>}
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
