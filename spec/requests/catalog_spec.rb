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
  # Example: It used to be that archive search had sort='score desc, date_of_capture_yyyymmdd desc'
  # find_site had sort='score desc'.  If there was no sort param in the HTTP query string
  # then the FindSiteSearchConfigurator would attempt to set the sort field to
  # 'score desc, date_of_capture_yyyymmdd desc', causing a SOLR error.
  describe 'over multiple searches' do

    # Use top form for first test and in-page form for second test to exercise both forms
    it 'can successfully run a find_site search immediately after an archive search', :js => true do
      visit '/search'

      fill_in 'q', :with => 'women'
      find('#search_type_find_site').click()
      click_link 'top_form_submit'
      page.source.match( /REQUEST_TEST_STRING: Hrwa::CATALOG::RESULT_LIST::RENDER_SUCCESS/ ).should_not be_nil

      visit '/search'
      fill_in 'q', :with => 'water'
      find('#search_type_archive').click()
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
    find('#search_type_archive').click()
    click_link 'top_form_submit'

    querystring = URI.parse( current_url ).query
    params_hash = Rack::Utils.parse_nested_query( querystring ).deep_symbolize_keys
    params_hash[ :host ].should be_nil
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
    visit '/search?excl_domain%5B%5D=www.privacyinternational.org&f%5Blanguage__facet%5D%5B%5D=English&debug_mode=true&q=Privacy+International&search=true&search_type=archive&utf8=%E2%9C%93'
    page.should have_content( %q{"fq"=> ["{!raw f=language__facet}English", "-domain:www.privacyinternational.org"]} )
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


  it 'returns search results for a known successful query', :js => true do
    visit '/search'
    fill_in 'q', :with => 'water'
    find('#search_type_find_site').click()
    click_link 'top_form_submit'
    page.should have_content('Center for Economic and Social Rights')
  end

end



describe 'archive page search' do

  it 'returns search results for a known successful query', :js => true do
    visit '/search'
    fill_in 'q', :with => 'water'
    find('#search_type_archive').click()
    click_link 'top_form_submit'
    page.should have_content('Displaying page 1')
  end

  it 'shows expansion options for a known expandable query', :js => true do
    visit '/search'
    fill_in 'q', :with => 'aleuts'
    find('#search_type_archive').click()
    click_link 'top_form_submit'
    page.should have_content('Expanded search terms were found for this query!')
    find('#expansion_on').click()
    page.should have_content('Your search has been expanded to include the following terms:')
    page.should have_content('Unangan')
  end

  it 'shows search extension options and links properly to extension sites for a known extendable query', :js => true do
    visit '/search'
    fill_in 'q', :with => 'water'
    find('#search_type_archive').click()
    click_link 'top_form_submit'
    click_link 'search_extension_tab'

    page.should have_content('Try your search in one of these related resources')

    page.should have_content('Archive-It')
    click_link 'archiveit_expansion_hidden_testing_link'
    page.should have_content('The following results were found for the term(s): water')

    page.evaluate_script('window.history.back()')

    page.should have_content('HuriSearch')
    click_link 'hurisearch_expansion_hidden_testing_link'
    page.should have_content('water')
    page.should have_content('document(s) match your query')
    page.should_not have_content('0 document(s) match your query')

    page.evaluate_script('window.history.back()')

    page.should have_content('ArchiveGrid')
    click_link 'archivegrid_expansion_hidden_testing_link'
    page.should have_content('water')
    page.should have_content('Records 1 to 10')

    page.evaluate_script('window.history.back()')

    page.should have_content('Office of the High Commissioner for Human Rights, United Nations')
    click_link 'ohchr_expansion_hidden_testing_link'
    page.should have_content('Results 1 - 10')
    page.should have_content('for water')
    page.should_not have_content('did not match any documents')

    page.evaluate_script('window.history.back()')

    page.should have_content('Universal Human Rights Index, maintained by the OHCHR')
    click_link 'uhri_expansion_hidden_testing_link'
    page.should have_content('water')
    page.should have_content('Page 1 of')
    page.should_not have_content('No results found')

  end

end

describe 'site detail pages' do
  configurator        = Hrwa::SiteDetailConfigurator.new
  blacklight_config   = Blacklight::Configuration.new
  config_proc         = configurator.config_proc
  blacklight_config.configure &config_proc

  # Test below added to address https://issues.cul.columbia.edu/browse/HRWA-504
  it 'can properly load the amnesty.org site detail page', :js => true do
    visit '/search/5421151'
    page.should have_content('Amnesty International')
  end

  # Test below added to address https://issues.cul.columbia.edu/browse/HRWA-504
  it 'can properly load the safhr.org site detail page', :js => true do
    visit '/search/5533251'
    page.should have_content('South Asia Forum for Human Rights')
  end

  # Test below added to address https://issues.cul.columbia.edu/browse/HRWA-504
  it 'checks the find_site radio button when on a site detail page', :js => true do
    visit '/search/5533251'
    find("#search_type_find_site").should be_checked
  end

end

#describe 'error handler' do
#  it 'returns invalid query error to user when query is a single plus sign', :js => true do
#    visit '/search'
#
#  end
#end
