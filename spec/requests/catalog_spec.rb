# -*- encoding : utf-8 -*-
require 'spec_helper'

#Capybara.javascript_driver = :webkit
# Capybara.default_wait_time = 30

describe 'the portal search' do
  it 'renders the "search home page" if there are no params' do
    visit '/search'
    page.source.match( /REQUEST_TEST_STRING: HRWA::CATALOG::SEARCH_HOME::RENDER_SUCCESS/ ).should_not be nil
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
      page.source.match( /REQUEST_TEST_STRING: HRWA::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil

      visit '/search'
      fill_in 'q', :with => 'water'
      choose 'fsfsearch'
      click_link 'top_form_submit'
      page.source.match( /REQUEST_TEST_STRING: HRWA::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil
      page.source.match( /REQUEST_TEST_STRING: HRWA::CATALOG::ERROR::RENDER_SUCCESS/ ).should be_nil
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
      page.source.match( /REQUEST_TEST_STRING: HRWA::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil

      # visit '/search'
      # fill_in 'q', :with => 'women'
      # choose 'asfsearch'
      # click_link 'top_form_submit'
      visit '/search?utf8=%E2%9C%93&search=true&q=women&search_type=archive'
      page.source.match( /REQUEST_TEST_STRING: HRWA::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil
      page.source.match( /REQUEST_TEST_STRING: HRWA::CATALOG::ERROR::RENDER_SUCCESS/ ).should be_nil
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

  # HRWA-359 Bug
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
    configurator        = HRWA::ArchiveSearchConfigurator.new
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

  # TODO: Get these tests working
  ## We don't have a way of using capybara to slide the sliders,
  ## so this text involves going to a url in which the sliders are already set, but
  ## then we re-submit the form to make sure that the sliders preserve the value in
  ## the params and then resubmit that value properly.
  #describe 'SOLR field boost level overriding', :focus => true do
  #  it 'correctly sets new weights for contentBody, contentTitle, and originalUrl', :focus => true do
  #
  #    visit '/search?field%5B%5D=originalUrl%5E2&field%5B%5D=contentTitle%5E3&field%5B%5D=contentBody%5E4&hrwa_debug=true'
  #    choose 'asfsearch'
  #    click_link 'advo_link'
  #    click_link 'top_form_submit'
  #    page.should have_content( %q{:qf=>["originalUrl^2", "contentTitle^3", "contentBody^4"]} )
  #  end
  #
  #  it 'correctly sets new weights for contentBody, contentTitle, with originalUrl omitted' do
  #    visit 'http://bronte.cul.columbia.edu:3020/search?utf8=%E2%9C%93&search=true&hrwa_debug=true&field%5B%5D=contentTitle%5E3&field%5B%5D=contentBody%5E4&search_mode=advanced&q_phrase=&capture_start_date=&capture_end_date=&per_page=10&sort=score+desc&search_type=archive&search_mode=advanced&q_and=women&q_phrase=&q_or=&q_exclude=&capture_start_date=&capture_end_date=&per_page=10&sort=score+desc'
  #    page.should have_content( %q{:qf=>["contentTitle^3", "contentBody^4"]} )
  #  end
  #end

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
      fill_in 'capture_end_date',   :with => '2012-03'
      fill_in 'capture_start_date', :with => '2008-03'
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

      page.current_url.should have_content( 'field%5B%5D=originalUrl%5E1&field%5B%5D=contentTitle%5E1&field%5B%5D=contentBody%5E1' )
    end

  end
end

describe 'find site search' do
  configurator        = HRWA::FindSiteSearchConfigurator.new
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

end

describe 'javascript two-way query conversion tests' do

  it 'properly converts multi q to single q', :js => true do
    visit '/search'
    click_link 'advo_link'

    #test 1 - basic test
    fill_in 'q_and', :with => 'and1 and2 and3'
    fill_in 'q_phrase', :with => 'an exact phrase'
    fill_in 'q_or', :with => 'or1 or2 or3'
    fill_in 'q_exclude', :with => 'exclude1 exclude2 exclude3'
    find_field('q').value.should == '+and1 +and2 +and3 "an exact phrase" or1 or2 or3 -exclude1 -exclude2 -exclude3'

    #clear all q's
    fill_in 'q_and', :with => ''
    fill_in 'q_phrase', :with => ''
    fill_in 'q_or', :with => ''
    fill_in 'q_exclude', :with => ''
  end

  it 'properly converts single q to multi q', :js => true do
    visit '/search'

    #test 1 - basic test
    fill_in 'q', :with => '+and1 +and2 +and3 "an exact phrase" or1 or2 or3 -exclude1 -exclude2 -exclude3'
    click_link 'advo_link'
    find_field('q_and').value.should == 'and1 and2 and3'
    find_field('q_phrase').value.should == 'an exact phrase'
    find_field('q_or').value.should == 'or1 or2 or3'
    find_field('q_exclude').value.should == 'exclude1 exclude2 exclude3'

    #clear q
    fill_in 'q', :with => ''

    #test 2 - q starts with a quote
    fill_in 'q', :with => '"an exact phrase" +and1 +and2 +and3 or1 or2 or3 -exclude1 -exclude2 -exclude3'
    click_link 'advo_link'
    find_field('q_and').value.should == 'and1 and2 and3'
    find_field('q_phrase').value.should == 'an exact phrase'
    find_field('q_or').value.should == 'or1 or2 or3'
    find_field('q_exclude').value.should == 'exclude1 exclude2 exclude3'

    #clear q
    fill_in 'q', :with => ''

    #test 3 - q ends with a quote
    fill_in 'q', :with => '+and1 +and2 +and3 or1 or2 or3 -exclude1 -exclude2 -exclude3 "an exact phrase"'
    click_link 'advo_link'
    find_field('q_and').value.should == 'and1 and2 and3'
    find_field('q_phrase').value.should == 'an exact phrase'
    find_field('q_or').value.should == 'or1 or2 or3'
    find_field('q_exclude').value.should == 'exclude1 exclude2 exclude3'

    #clear q
    fill_in 'q', :with => ''

    #test 4 - lots of unnecessary spaces in q
    fill_in 'q', :with => '     +and1 +and2      +and3    "an exact phrase"    or1      or2      or3     -exclude1     -exclude2 -exclude3     '
    click_link 'advo_link'
    find_field('q_and').value.should == 'and1 and2 and3'
    find_field('q_phrase').value.should == 'an exact phrase'
    find_field('q_or').value.should == 'or1 or2 or3'
    find_field('q_exclude').value.should == 'exclude1 exclude2 exclude3'

    #clear q
    fill_in 'q', :with => ''

    #test 5 - detached pluses and minuses (if a plus or minus sign is alone, it's treated as a lone character rather than a special solr syntax item)
    fill_in 'q', :with => '+ and1 + and2 +and3 "an exact phrase" or1 or2 or3 - exclude1 - exclude2 -exclude3'
    click_link 'advo_link'
    find_field('q_and').value.should == 'and3'
    find_field('q_phrase').value.should == 'an exact phrase'
    find_field('q_or').value.should == '+ and1 + and2 or1 or2 or3 - exclude1 - exclude2'
    find_field('q_exclude').value.should == 'exclude3'
  end

end
