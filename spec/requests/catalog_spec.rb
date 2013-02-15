# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.configure do | config |
  # Certain features were broken during the down-migration to Solr 3.6
  # We don't want to forget about them, but we don't know when we'll be
  # re-enabling the features
  config.filter_run_excluding :broken => true
end

Capybara.javascript_driver = :webkit
#Capybara.default_wait_time = 30

describe 'the portal search' do
  it 'renders the "search home page" if there are no params' do
    visit '/search'
    page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::SEARCH_HOME::RENDER_SUCCESS/ ).should_not be nil
  end

  # JIRA issue: https://issues.cul.columbia.edu/browse/HRWA-324
  # CatalogController is apparently re-used.  If blacklight_config of the CatalogController
  # is not reset to a blank state reset to blank state in each request, there is
  # the potential for a SOLR error to occur due to old stuff such as config.facet_fields and
  # config.sort_fields defined in the previous request referencing SOLR fields that don't exist in the
  # SOLR index for the current search_type.
  #
  # Example: It used to be that archive search had sort='score desc, dateOfCaptureYYYYMMDD desc'
  # find_site had sort='score desc'.  If there was no sort param in the HTTP query string
  # then the FindSiteSearchConfigurator would attempt to set the sort field to
  # 'score desc, dateOfCaptureYYYYMMDD desc', causing a SOLR error.
  describe 'over multiple searches' do

    # Use top form for first test and in-page form for second test to exercise both forms
    it 'can successfully run a find_site search immediately after an archive search', :js => true do
      visit '/search'
      fill_in 'q', :with => 'women'
      choose 'asfsearch'
      click_link 'top_form_submit'
      page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil

      visit '/search'
      fill_in 'q', :with => 'water'
      choose 'fsfsearch'
      click_link 'top_form_submit'
      page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil
      page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::ERROR::RENDER_SUCCESS/ ).should be_nil
    end

    # TODO: For some reason this test fails using form fill-in when running full test suite,
    # but not when running just this spec file.  Once this is debugged, convert this back into
    # a form fill-in test.  The page source has <noscript> in it, which would indicate that
    # :js => true is not doing its job.
    it 'can successfully run an archive search immediately after a find_site search', :js => true do
      # visit '/search'
      # fill_in 'q', :with => 'water'
      # choose 'fsfsearch'
      # click_link 'top_form_submit'
      visit '/search?utf8=%E2%9C%93&search=true&q=water&search_type=find_site'
      page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil

      # visit '/search'
      # fill_in 'q', :with => 'women'
      # choose 'asfsearch'
      # click_link 'top_form_submit'
      visit '/search?utf8=%E2%9C%93&search=true&q=women&search_type=archive'
      page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil
      page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::ERROR::RENDER_SUCCESS/ ).should be_nil
    end
  end

end

describe 'archive search' do
  it 'should not have "host" param in querystring', :js => true do
    visit '/search'
    fill_in 'q', :with => 'water'
    choose 'asfsearch'
    click_link 'top_form_submit'

    querystring = URI.parse( current_url ).query
    params_hash = Rack::Utils.parse_nested_query( querystring ).deep_symbolize_keys
    params_hash[ :host ].should be_nil
  end

  # https://issues.cul.columbia.edu/browse/HRWA-392
  it 'shows 10 for end of results range for q="rights"', :js => true do
    visit '/search'
    fill_in 'q', :with => 'rights'
    choose 'asfsearch'
    click_link 'top_form_submit'
    page.should have_content( '1 - 10' )
  end

  # https://issues.cul.columbia.edu/browse/HRWA-359 Bug
  it 'does not wipe out facet fq params when a exclude domain filter is specified', :js => true do
    # TODO: right now no way to click on the correct Domain- button so using visit URL.
    # Convert this to form fill-in when possible
    # visit '/search'
    # choose 'asfsearch'
    # fill_in 'q', :with => 'shirkatgah.org'
    # click_link 'top_form_submit'
    # click_link 'English'
    # clink_link 'Domain-'
    # click_link 'Menu'
    # click_link 'Turn debug on'
    visit '/search?excl_domain%5B%5D=www.privacyinternational.org&f%5Blanguage__facet%5D%5B%5D=English&hrwa_debug=true&q=Privacy+International&search=true&search_type=archive&utf8=%E2%9C%93'
    page.should have_content( %q{fq = ["{!raw f=language__facet}English", "-domain:www.privacyinternational.org"]} )
  end

  # TODO: Finish writing this test
  # Exclude domain filter bug - For some reason, domain exclusions keep adding unnecessary extra domains that were never selected by the user.
  # Example link: http://localhost:3020/search?excl_domain[]=aaa&f[organization_based_in__facet][]=England&q=rights&search=true&search_type=archive&utf8=%E2%9C%93
  # Go to the link above and click the submit button without changing any other search options.  The result count shouldn't change, but it does!
  it 'does not randomly add extra excl_domain filters that were not added by the user', :js => true do
    # visit '/search?excl_domain[]=aaa&f[organization_based_in__facet][]=England&q=rights&search=true&search_type=archive&utf8=%E2%9C%93'
    #page.should have_content( '407,366' )
    # click_link 'top_form_submit'
    #page.should have_content( '407,366' )
  end

  # TODO: For some reason this test fails using form fill-in when running full test suite,
  # but not when running just this spec file.  Once this is debugged, convert this back into
  # a form fill-in test.  The page source has <noscript> in it, which would indicate that
  # :js => true is not doing its job.
  it 'does not raise an error when paging through results', :js => true do
    # visit '/search'
    # fill_in 'q', :with => 'water'
    # choose 'asfsearch'
    # click_link 'top_form_submit'
    # click_link '3'
    visit '/search?page=3&q=water&search=true&search_type=archive&utf8=%E2%9C%93'
    page.should_not have_content( %q{can't convert Fixnum into String} )
  end

  describe 'facets' do
    configurator        = Hrwa::ArchiveSearchConfigurator.new
    blacklight_config   = Blacklight::Configuration.new
    config_proc         = configurator.config_proc
    blacklight_config.configure &config_proc

     blacklight_config.facet_fields.each { | facet_name, facet_field |
      it "has working pagination for #{ facet_name } facet" do
        visit "/catalog/facet/#{ facet_name }?q=rights&search=true&search_type=archive&utf8=%E2%9C%93"
        page.should have_content( facet_field.label )
        page.status_code.should == 200
      end
    }
  end

  # We don't have a way of using capybara to slide the sliders, so this test
  # involves going to a url in which the sliders are already set, but
  # no other form settings are set.  Then we re-submit the form to make sure
  # that the sliders preserve the query string values and properly resubmit
  # them with the other new form values.
  describe 'SOLR field boost level overriding' do
    it 'correctly sets new weights for contents, title, and originalUrl', :js => true do

      visit '/search?field%5B%5D=originalUrl%5E2&field%5B%5D=title%5E3&field%5B%5D=contents%5E4&hrwa_debug=true'
      choose 'asfsearch'
      click_link 'advo_link'
      click_link 'top_form_submit'
      page.should have_content( %q{:qf=>["originalUrl^2", "title^3", "contents^4"]} )
    end

    it 'correctly sets new weights for contents, title and originalUrl, with originalUrl omitted in form submission', :js => true do
      visit '/search?field%5B%5D=title%5E3&field%5B%5D=contents%5E4&hrwa_debug=true'
      choose 'asfsearch'
      click_link 'advo_link'
      click_link 'top_form_submit'
      page.should have_content( %q{:qf=>["originalUrl^1", "title^3", "contents^4"]} )
    end
  end

  describe 'advanced mode' do
    it 'informs user "No results found" if advanced search returns no hits', :js => true do
      visit '/search'
      choose 'asfsearch'
      click_link 'advo_link'
      fill_in 'q_and', :with => 'zzzzzzzzzzzzzzzzzzaaaaaaaaaaaaaaaa'
      click_link 'top_form_submit'
      page.should have_content('No results found')
    end

    it 'returns 2,306 results for q_and=women', :js => true do
      visit '/search'
      choose 'asfsearch'
      click_link 'advo_link'
      fill_in 'q_and', :with => 'women'
      click_link 'top_form_submit'
      page.should have_content( '2,306' )
    end

    # HRWA-359 Bug
    it 'does not wipe out facet fq params when a Date of Capture filter is specified', :js => true do
      visit '/search'
      choose 'asfsearch'
      click_link 'advo_link'
      fill_in 'q_and',              :with => 'women'
      find('.capture_start_date_group select.year').select('2008')
      find('.capture_start_date_group select.month').select('Mar')
      find('.capture_end_date_group select.year').select('2012')
      find('.capture_end_date_group select.month').select('Mar')
      click_link 'top_form_submit'
      click_link 'English'
      click_link 'Menu'
      click_link 'Turn debug on'
      page.should have_content( %q{fq = ["{!raw f=language__facet}English", "dateOfCaptureYYYYMM:[ 200803 TO 201203 ]"]} )
    end

    # TODO: HRWA-375 Bug Test
    #it 'does not create duplicate pills during an advanced search', :js => true do
    #  visit '/search'
    #  choose 'asfsearch'
    #  click_link 'advo_link'
    #  # ...other stuff here... (select items in <select> elements)
    #  click_link 'top_form_submit'
    #  click_link 'English'
    #  #page.should_not have_content( %q{...put adjacent duplicate pill html here...} )
    #end

    # Slider test in advanced form (for the 'field' query string parameter )
    it 'submits the slider values in the advanced form so that they appear in the form-generated url', :js => true do
      visit '/search'
      choose 'asfsearch'
      click_link 'advo_link'
      click_link 'top_form_submit'

      page.current_url.should have_content( 'field%5B%5D=originalUrl%5E1&field%5B%5D=title%5E1&field%5B%5D=contents%5E1' )
    end

    describe 'archive search hrwa_host override dropdown' do
        it 'correctly selects the Dev override server', :js => true do
          visit '/search'
          click_link 'Menu'
          click_link 'Turn debug on'
          choose 'asfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          find('#hrwa_host_asf').select('Dev')
          click_link 'top_form_submit'
          page.should have_content( %q{solr_url = http://carter.cul.columbia.edu:8080/solr-3.6/asf} )
        end

        it 'correctly selects the Test override server', :js => true do
          visit '/search'
          click_link 'Menu'
          click_link 'Turn debug on'
          choose 'asfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          find('#hrwa_host_asf').select('Test')
          click_link 'top_form_submit'
          page.should have_content( %q{solr_url = http://harding.cul.columbia.edu:8080/solr-3.6/asf} )
        end

        it 'correctly selects the Prod override server', :js => true do
          visit '/search'
          click_link 'Menu'
          click_link 'Turn debug on'
          choose 'asfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          find('#hrwa_host_asf').select('Prod')
          click_link 'top_form_submit'
          page.should have_content( %q{solr_url = http://vorpal.cul.columbia.edu:8080/solr-3.6/asf} )
        end
    end

    # Temporarily disabled until asf-hrwa-278 can be down-migrated to Solr 3.6
    describe 'non-stemmed search boosting', :broken => true do

        it 'enables boosting when the boost checkbox is checked, and debug mode indicates that it is using the correct core', :js => true do
          visit '/search?&field%5B%5D=originalUrl%5E1&field%5B%5D=title%5E1&field%5B%5D=contents%5E1&field%5B%5D=originalUrl__no_stemming_balancing_field%5E23&field%5B%5D=title__no_stemming%5E23&field%5B%5D=contents__no_stemming%5E23'
          click_link 'Menu'
          click_link 'Turn debug on'
          choose 'asfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          check('enable_ns_boost_checkbox')
          click_link 'top_form_submit'
          page.should have_content( %q{solr_url = http://carter.cul.columbia.edu:8080/solr-3.6/asf-hrwa-278} )
        end

        it 'uses the boost values that are set in the advanced search form', :js => true do
          visit '/search?field%5B%5D=originalUrl%5E10&field%5B%5D=title%5E20&field%5B%5D=contents%5E30&field%5B%5D=originalUrl__no_stemming_balancing_field%5E20&field%5B%5D=title__no_stemming%5E40&field%5B%5D=contents__no_stemming%5E60'
          click_link 'Menu'
          click_link 'Turn debug on'
          choose 'asfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          check('enable_ns_boost_checkbox')
          click_link 'top_form_submit'
          page.should have_content( %q{field = ["originalUrl^10", "title^20", "contents^30", "originalUrl__no_stemming_balancing_field^20", "title__no_stemming^40", "contents__no_stemming^60"]} )
        end

        it 'displays a notice to users when they are performing a non-stemmed search', :js => true do
          visit '/search'
          choose 'asfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          check('enable_ns_boost_checkbox')
          click_link 'top_form_submit'
          page.should have_content( %q{You are currently performing a limited-result search that favors non-stemmed field searching.} )
        end

    end

  end
end

describe 'find site search' do
  configurator        = Hrwa::FindSiteSearchConfigurator.new
  blacklight_config   = Blacklight::Configuration.new
  config_proc         = configurator.config_proc
  blacklight_config.configure &config_proc

  blacklight_config.facet_fields.each { | facet_name, facet_field |
    it "has working pagination for #{ facet_name } facet" do
      visit "/catalog/facet/#{ facet_name }?q=rights&search=true&search_type=find_site&utf8=%E2%9C%93"
      page.should have_content( facet_field.label )
      page.status_code.should == 200
    end
  }

  describe 'advanced mode' do
    it 'informs user "No results found" if advanced search returns no hits', :js => true do
      visit '/search'
      click_link 'advo_link'
      fill_in 'q_and', :with => 'zzzzzzzzzzzzzzzzzzaaaaaaaaaaaaaaaa'
      click_link 'top_form_submit'
      page.should have_content('No results found')
    end

    it 'returns search results for a known successful query', :js => true do
      visit '/search'
      click_link 'advo_link'
      fill_in 'q_and', :with => 'water'
      fill_in 'q_phrase', :with => 'Provides information'
      fill_in 'q_or', :with => 'human rights'
      fill_in 'q_exclude', :with => 'zamboni'
      click_link 'top_form_submit'
      page.should have_content('Center for Economic and Social Rights')
    end
  end

  describe 'find_site search hrwa_host override dropdown' do
        it 'correctly selects the Dev override server', :js => true do
          visit '/search'
          click_link 'Menu'
          click_link 'Turn debug on'
          choose 'fsfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          find('#hrwa_host_fsf').select('Dev')
          click_link 'top_form_submit'
          page.should have_content( %q{solr_url = http://carter.cul.columbia.edu:8080/solr-3.6/fsf} )
        end

        it 'correctly selects the Test override server', :js => true do
          visit '/search'
          click_link 'Menu'
          click_link 'Turn debug on'
          choose 'fsfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          find('#hrwa_host_fsf').select('Test')
          click_link 'top_form_submit'
          page.should have_content( %q{solr_url = http://harding.cul.columbia.edu:8080/solr-3.6/fsf} )
        end

        it 'correctly selects the Prod override server', :js => true do
          visit '/search'
          click_link 'Menu'
          click_link 'Turn debug on'
          choose 'fsfsearch'
          click_link 'advo_link'
          fill_in 'q_and', :with => 'women'
          find('#hrwa_host_fsf').select('Prod')
          click_link 'top_form_submit'
          page.should have_content( %q{solr_url = http://vorpal.cul.columbia.edu:8080/solr-3.6/fsf} )
        end
    end

end

describe 'site detail pages' do
  configurator        = Hrwa::SiteDetailConfigurator.new
  blacklight_config   = Blacklight::Configuration.new
  config_proc         = configurator.config_proc
  blacklight_config.configure &config_proc

  # Test below added to address https://issues.cul.columbia.edu/browse/HRWA-504
  it 'can properly load the amnesty.org site detail page', :js => true do
    visit '/site_detail/5421151'
    page.should have_content('Amnesty International')
  end

  # Test below added to address https://issues.cul.columbia.edu/browse/HRWA-504
  it 'can properly load the safhr.org site detail page', :js => true do
    visit '/site_detail/5533251'
    page.should have_content('South Asia Forum for Human Rights')
  end

  # Test below added to address https://issues.cul.columbia.edu/browse/HRWA-504
  it 'checks the find_site radio button when on a site_detail page', :js => true do
    visit '/site_detail/5533251'
    find("#fsfsearch").should be_checked
  end

end

describe 'javascript two-way query conversion' do

  describe 'proper multi q to single q conversion', :js => true do

		before :each do
			visit '/search'
		end

    it 'succeeds at a basic test' do
			click_link 'advo_link'
			fill_in 'q_and', :with => 'and1 and2 and3'
			fill_in 'q_phrase', :with => 'an exact phrase'
			fill_in 'q_or', :with => 'or1 or2 or3'
			fill_in 'q_exclude', :with => 'exclude1 exclude2 exclude3'
			find_field('q').value.should == '+and1 +and2 +and3 "an exact phrase" or1 or2 or3 -exclude1 -exclude2 -exclude3'
    end

  end

  describe 'proper single q to multi q conversion', :js => true do

    before :each do
        visit '/search'
    end

    it 'succeeds at a basic test' do
        fill_in 'q', :with => '+and1 +and2 +and3 "an exact phrase" or1 or2 or3 -exclude1 -exclude2 -exclude3'
        click_link 'advo_link'
        find_field('q_and').value.should == 'and1 and2 and3'
        find_field('q_phrase').value.should == 'an exact phrase'
        find_field('q_or').value.should == 'or1 or2 or3'
        find_field('q_exclude').value.should == 'exclude1 exclude2 exclude3'
    end

    it 'works when q starts with a double quote' do
        fill_in 'q', :with => '"an exact phrase" +and1 +and2 +and3 or1 or2 or3 -exclude1 -exclude2 -exclude3'
        click_link 'advo_link'
        find_field('q_and').value.should == 'and1 and2 and3'
        find_field('q_phrase').value.should == 'an exact phrase'
        find_field('q_or').value.should == 'or1 or2 or3'
        find_field('q_exclude').value.should == 'exclude1 exclude2 exclude3'
    end

    it 'works when q ends with a double quote' do
        fill_in 'q', :with => '+and1 +and2 +and3 or1 or2 or3 -exclude1 -exclude2 -exclude3 "an exact phrase"'
        click_link 'advo_link'
        find_field('q_and').value.should == 'and1 and2 and3'
        find_field('q_phrase').value.should == 'an exact phrase'
        find_field('q_or').value.should == 'or1 or2 or3'
        find_field('q_exclude').value.should == 'exclude1 exclude2 exclude3'
    end

it 'works when q has lots of unnecessary extra spaces' do
        fill_in 'q', :with => '     +and1 +and2      +and3    "an exact phrase"    or1      or2      or3     -exclude1     -exclude2 -exclude3     '
        click_link 'advo_link'
        find_field('q_and').value.should == 'and1 and2 and3'
        find_field('q_phrase').value.should == 'an exact phrase'
        find_field('q_or').value.should == 'or1 or2 or3'
        find_field('q_exclude').value.should == 'exclude1 exclude2 exclude3'
    end

    it 'works when q has lots of detached pluses and minuses (if a plus or minus sign is alone, it\'s treated as a lone character rather than a special solr syntax item)' do
        fill_in 'q', :with => '+ and1 + and2 +and3 "an exact phrase" or1 or2 or3 - exclude1 - exclude2 -exclude3'
        click_link 'advo_link'
        find_field('q_and').value.should == 'and3'
        find_field('q_phrase').value.should == 'an exact phrase'
        find_field('q_or').value.should == '+ and1 + and2 or1 or2 or3 - exclude1 - exclude2'
        find_field('q_exclude').value.should == 'exclude3'
    end

  end

end

describe 'error handler' do
  it 'returns invalid query error to user when query is a single plus sign', :js => true do
    visit '/search'

    fill_in 'q', :with => '+'
    click_link 'top_form_submit'

    # TODO: change this from a page scan to just referencing whatever div the Eri[ck]s put the
    # error text in
    page.should have_content( '"+" is not valid.' )
    page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::ERROR::RENDER_SUCCESS/ ).should_not be_nil
  end
end
