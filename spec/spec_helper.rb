require 'rubygems'
require 'spork'

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rails'
  require 'capybara/rspec'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true
    config.include(MailerMacros)
    config.before(:each) { reset_email }

    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
  end
  
  def mock_query_response_grouped
    %({"responseHeader"=>
    {"status"=>0,
     "QTime"=>743,
     "params"=>
      {"f.contentMetaLanguage.facet.limit"=>"11",
       "facet"=>"true",
       "sort"=>"score desc",
       "group.limit"=>"10",
       "spellcheck.q"=>"+women",
       "q.alt"=>"*:*",
       "f.dateOfCaptureYYYY.facet.limit"=>"11",
       "f.organization_type__facet.facet.limit"=>"11",
       "f.language__facet.facet.limit"=>"11",
       "f.mimetype.facet.limit"=>"11",
       "group.field"=>"originalUrl",
       "facet.field"=>
        ["domain",
         "geographic_focus__facet",
         "organization_based_in__facet",
         "organization_type__facet",
         "language__facet",
         "contentMetaLanguage",
         "creator_name__facet",
         "mimetype",
         "dateOfCaptureYYYY"],
       "f.creator_name__facet.facet.limit"=>"11",
       "facet.mincount"=>"1",
       "qf"=>
        ["contentTitle^1",
         "contntBody^1",
         "contentMetaDescription^1",
         "contentMetaKeywords^1",
         "contentMetaLanguage^1",
         "contentBodyHeading1^1",
         "contentBodyHeading2^1",
         "contentBodyHeading3^1",
         "contentBodyHeading4^1",
         "contentBodyHeading5^1",
         "contentBodyHeading6^1"],
       "wt"=>"ruby",
       "f.geographic_focus__facet.facet.limit"=>"11",
       "defType"=>"dismax",
       "rows"=>"10",
       "f.domain.facet.limit"=>"11",
       "f.organization_based_in__facet.facet.limit"=>"11",
       "start"=>50,
       "q"=>"+women",
       "group"=>"true"}},
   "grouped"=>
    {"originalUrl"=>
      {"matches"=>1064474,
       "groups"=>
        [{"groupValue"=>"http://www.hrw.org/he/keywords/women",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"contentTitle"=>"Taxonomy | Human Rights Watch",
               "originalUrl"=>"http://www.hrw.org/he/keywords/women",
               "dateOfCaptureYYYY"=>"2011",
               "statusCode"=>"200",
               "timestamp"=>"2011-09-29T21:39:45.041Z",
               "dateOfCaptureYYYYMMDD"=>"20110606",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20110606222047/http://www.hrw.org/he/keywords/women",
               "recordDate"=>"20110606222047",
               "contentMetaKeywords"=>"women",
               "recordIdentifier"=>
                "20110606222047/http://www.hrw.org/he/keywords/women",
               "contentBody"=>
                "This is a doc.",
               "length"=>13970,
               "filename"=>
                "ARCHIVEIT-1068-BIMONTHLY-QXGACE-20110606220953-00002-crawling207.us.archive.org-6680.warc.gz",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2011_06/ARCHIVEIT-1068-BIMONTHLY-QXGACE-20110606220953-00002-crawling207.us.archive.org-6680.warc.gz",
               "digest"=>"sha1:JTTZZQQNH2MXEH4LHABXR2RT7Y6EFZNR",
               "mimetype"=>"text/html; charset=utf-8",
               "dateOfCaptureYYYYMM"=>"201106",
               "bib_key"=>"4391359",
               "organization_based_in__facet"=>"New York (State)",
               "organization_based_in"=>"New York (State)",
               "organization_type"=>"Non-governmental organizations",
               "organization_type__facet"=>"Non-governmental organizations",
               "website_original_urls"=>["http://www.hrw.org/"],
               "contentBodyHeading6"=>["women"],
               "contentBodyHeading5"=>[""],
               "contentBodyHeading4"=>[""],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>["This is a heading."],
               "contentBodyHeading1"=>[""],
               "geographic_focus"=>[" [043 CODE NOT FOUND IN MARC LIST]"],
               "creator_name__facet"=>["Human Rights Watch (Organization)"],
               "geographic_focus__facet"=>[" [043 CODE NOT FOUND IN MARC LIST]"],
               "domain"=>["www.hrw.org"],
               "creator_name"=>["Human Rights Watch (Organization)"],
               "language"=>["English"],
               "language__facet"=>["English"]}]}},
         {"groupValue"=>"http://www.hrw.org/es/keywords/women",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"contentTitle"=>"Taxonomy | Human Rights Watch",
               "originalUrl"=>"http://www.hrw.org/es/keywords/women",
               "dateOfCaptureYYYY"=>"2011",
               "statusCode"=>"200",
               "timestamp"=>"2011-09-29T21:39:51.012Z",
               "dateOfCaptureYYYYMMDD"=>"20110606",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20110606223240/http://www.hrw.org/es/keywords/women",
               "recordDate"=>"20110606223240",
               "contentMetaKeywords"=>"women",
               "recordIdentifier"=>
                "20110606223240/http://www.hrw.org/es/keywords/women",
               "contentBody"=>
                "This is a doc.",
               "length"=>17089,
               "filename"=>
                "ARCHIVEIT-1068-BIMONTHLY-QXGACE-20110606220953-00002-crawling207.us.archive.org-6680.warc.gz",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2011_06/ARCHIVEIT-1068-BIMONTHLY-QXGACE-20110606220953-00002-crawling207.us.archive.org-6680.warc.gz",
               "digest"=>"sha1:G4WW5I26EPHCPFQ6SZOMBQU2MBYN7ASA",
               "mimetype"=>"text/html; charset=utf-8",
               "dateOfCaptureYYYYMM"=>"201106",
               "bib_key"=>"4391359",
               "organization_based_in__facet"=>"New York (State)",
               "organization_based_in"=>"New York (State)",
               "organization_type"=>"Non-governmental organizations",
               "organization_type__facet"=>"Non-governmental organizations",
               "website_original_urls"=>["http://www.hrw.org/"],
               "contentBodyHeading6"=>["women"],
               "contentBodyHeading5"=>[""],
               "contentBodyHeading4"=>[""],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>["Informes"],
               "contentBodyHeading1"=>[""],
               "geographic_focus"=>[" [043 CODE NOT FOUND IN MARC LIST]"],
               "creator_name__facet"=>["Human Rights Watch (Organization)"],
               "geographic_focus__facet"=>[" [043 CODE NOT FOUND IN MARC LIST]"],
               "domain"=>["www.hrw.org"],
               "creator_name"=>["Human Rights Watch (Organization)"],
               "language"=>["English"],
               "language__facet"=>["English"]}]}},
         {"groupValue"=>"http://www.hrw.org/en/keywords/women",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"contentTitle"=>"women | Human Rights Watch",
               "originalUrl"=>"http://www.hrw.org/en/keywords/women",
               "dateOfCaptureYYYY"=>"2011",
               "statusCode"=>"200",
               "timestamp"=>"2011-09-29T21:41:54.223Z",
               "dateOfCaptureYYYYMMDD"=>"20110607",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20110607054349/http://www.hrw.org/en/keywords/women",
               "recordDate"=>"20110607054349",
               "contentMetaKeywords"=>"women",
               "recordIdentifier"=>
                "20110607054349/http://www.hrw.org/en/keywords/women",
               "contentBody"=>
                "This is a doc.",
               "length"=>19954,
               "filename"=>
                "ARCHIVEIT-1068-BIMONTHLY-QXGACE-20110607044225-00021-crawling207.us.archive.org-6680.warc.gz",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2011_06/ARCHIVEIT-1068-BIMONTHLY-QXGACE-20110607044225-00021-crawling207.us.archive.org-6680.warc.gz",
               "digest"=>"sha1:QY4XD7BFV3OAJMRQX2BDOTLJWA6DWGBQ",
               "mimetype"=>"text/html; charset=utf-8",
               "dateOfCaptureYYYYMM"=>"201106",
               "bib_key"=>"4391359",
               "organization_based_in__facet"=>"New York (State)",
               "organization_based_in"=>"New York (State)",
               "organization_type"=>"Non-governmental organizations",
               "organization_type__facet"=>"Non-governmental organizations",
               "website_original_urls"=>["http://www.hrw.org/"],
               "contentBodyHeading6"=>["women"],
               "contentBodyHeading5"=>[""],
               "contentBodyHeading4"=>[""],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>["Reports"],
               "contentBodyHeading1"=>[""],
               "geographic_focus"=>[" [043 CODE NOT FOUND IN MARC LIST]"],
               "creator_name__facet"=>["Human Rights Watch (Organization)"],
               "geographic_focus__facet"=>[" [043 CODE NOT FOUND IN MARC LIST]"],
               "domain"=>["www.hrw.org"],
               "creator_name"=>["Human Rights Watch (Organization)"],
               "language"=>["English"],
               "language__facet"=>["English"]}]}},
         {"groupValue"=>"http://www.hrw.org/fr/keywords/women",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"contentTitle"=>"Taxonomy | Human Rights Watch",
               "originalUrl"=>"http://www.hrw.org/fr/keywords/women",
               "dateOfCaptureYYYY"=>"2011",
               "statusCode"=>"200",
               "timestamp"=>"2011-09-29T21:44:10.051Z",
               "dateOfCaptureYYYYMMDD"=>"20110607",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20110607143029/http://www.hrw.org/fr/keywords/women",
               "recordDate"=>"20110607143029",
               "contentMetaKeywords"=>"women",
               "recordIdentifier"=>
                "20110607143029/http://www.hrw.org/fr/keywords/women",
               "contentBody"=>
                "This is a doc.",
               "length"=>14164,
               "filename"=>
                "ARCHIVEIT-1068-BIMONTHLY-QXGACE-20110607131404-00033-crawling207.us.archive.org-6680.warc.gz",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2011_06/ARCHIVEIT-1068-BIMONTHLY-QXGACE-20110607131404-00033-crawling207.us.archive.org-6680.warc.gz",
               "digest"=>"sha1:6AURPJVALKWLA2H2HUXCF7BFYL73JAJP",
               "mimetype"=>"text/html; charset=utf-8",
               "dateOfCaptureYYYYMM"=>"201106",
               "bib_key"=>"4391359",
               "organization_based_in__facet"=>"New York (State)",
               "organization_based_in"=>"New York (State)",
               "organization_type"=>"Non-governmental organizations",
               "organization_type__facet"=>"Non-governmental organizations",
               "website_original_urls"=>["http://www.hrw.org/"],
               "contentBodyHeading6"=>["women"],
               "contentBodyHeading5"=>[""],
               "contentBodyHeading4"=>[""],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>["Rapports"],
               "contentBodyHeading1"=>[""],
               "geographic_focus"=>[" [043 CODE NOT FOUND IN MARC LIST]"],
               "creator_name__facet"=>["Human Rights Watch (Organization)"],
               "geographic_focus__facet"=>[" [043 CODE NOT FOUND IN MARC LIST]"],
               "domain"=>["www.hrw.org"],
               "creator_name"=>["Human Rights Watch (Organization)"],
               "language"=>["English"],
               "language__facet"=>["English"]}]}},
         {"groupValue"=>"http://khpg.org/en/index.php?do=print&id=1272455398",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"digest"=>"sha1:YTEJYSMS2UOOI7PKB3DUN4JOOHX4CSFZ",
               "filename"=>
                "ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "length"=>5938,
               "mimetype"=>"text/html",
               "originalUrl"=>
                "http://khpg.org/en/index.php?do=print&id=1272455398",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2010_09/ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "recordDate"=>"20100904153026",
               "recordIdentifier"=>
                "20100904153026/http://khpg.org/en/index.php?do=print&id=1272455398",
               "statusCode"=>"200",
               "dateOfCaptureYYYY"=>"2010",
               "dateOfCaptureYYYYMM"=>"201009",
               "dateOfCaptureYYYYMMDD"=>"20100904",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20100904153026/http://khpg.org/en/index.php?do=print&id=1272455398",
               "contentBody"=>
                "This is a doc.",
               "contentTitle"=>"",
               "timestamp"=>"2011-09-30T17:55:06.78Z",
               "contentBodyHeading6"=>[""],
               "contentBodyHeading5"=>["Women's rights"],
               "contentBodyHeading4"=>
                ["Human Rights in Ukraine. Information website of the Kharkiv Human Rights Protection Group"],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>[""],
               "contentBodyHeading1"=>
                ["So what is positive in restricting women'sght to take part in government?"]}]}},
         {"groupValue"=>"http://khpg.org/en/index.php?do=print&id=1270822714",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"digest"=>"sha1:FQFO3BEPFBDE5ILK4EKKW75GBXJ62MXT",
               "filename"=>
                "ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "length"=>3979,
               "mimetype"=>"text/html",
               "originalUrl"=>
                "http://khpg.org/en/index.php?do=print&id=1270822714",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2010_09/ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "recordDate"=>"20100904153107",
               "recordIdentifier"=>
                "20100904153107/http://khpg.org/en/index.php?do=print&id=1270822714",
               "statusCode"=>"200",
               "dateOfCaptureYYYY"=>"2010",
               "dateOfCaptureYYYYMM"=>"201009",
               "dateOfCaptureYYYYMMDD"=>"20100904",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20100904153107/http://khpg.org/en/index.php?do=print&id=1270822714",
               "contentBody"=>
                "This is a doc.",
               "contentTitle"=>"",
               "timestamp"=>"2011-09-30T17:55:10.461Z",
               "contentBodyHeading6"=>[""],
               "contentBodyHeading5"=>["This is a heading."],
               "contentBodyHeading4"=>
                ["Human Rights in Ukraine. Information website of the Kharkiv Human Rights Protection Group"],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>[""],
               "contentBodyHeading1"=>
                ["Ukraine lagging behind in number of women in high office"]}]}},
         {"groupValue"=>"http://khpg.org/en/index.php?do=print&id=1270551304",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"digest"=>"sha1:XVSYPTXEPP5O6QE2VJMNHTBLMB3UDP24",
               "filename"=>
                "ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "length"=>4499,
               "mimetype"=>"text/html",
               "originalUrl"=>
                "http://khpg.org/en/index.php?do=print&id=1270551304",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2010_09/ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "recordDate"=>"20100904153148",
               "recordIdentifier"=>
                "20100904153148/http://khpg.org/en/index.php?do=print&id=1270551304",
               "statusCode"=>"200",
               "dateOfCaptureYYYY"=>"2010",
               "dateOfCaptureYYYYMM"=>"201009",
               "dateOfCaptureYYYYMMDD"=>"20100904",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20100904153148/http://khpg.org/en/index.php?do=print&id=1270551304",
               "contentBody"=>
                "This is a doc.",
               "contentTitle"=>"",
               "timestamp"=>"2011-09-30T17:55:14.853Z",
               "contentBodyHeading6"=>[""],
               "contentBodyHeading5"=>["This is a heading."],
               "contentBodyHeading4"=>
                ["Human Rights in Ukraine. Information website of the Kharkiv Human Rights Protection Group"],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>[""],
               "contentBodyHeading1"=>["Ukrainian women vs. Azarov"]}]}},
         {"groupValue"=>"http://khpg.org/en/index.php?do=print&id=1270203432",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"digest"=>"sha1:IINTMIDQKICXR6RS4CEWBG4FN23YAWYI",
               "filename"=>
                "ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "length"=>4630,
               "mimetype"=>"text/html",
               "originalUrl"=>
                "http://khpg.org/en/index.php?do=print&id=1270203432",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2010_09/ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "recordDate"=>"20100904153228",
               "recordIdentifier"=>
                "20100904153228/http://khpg.org/en/index.php?do=print&id=1270203432",
               "statusCode"=>"200",
               "dateOfCaptureYYYY"=>"2010",
               "dateOfCaptureYYYYMM"=>"201009",
               "dateOfCaptureYYYYMMDD"=>"20100904",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20100904153228/http://khpg.org/en/index.php?do=print&id=1270203432",
               "contentBody"=>
                "This is a doc.",
               "contentTitle"=>"",
               "timestamp"=>"2011-09-30T17:55:22.715Z",
               "contentBodyHeading6"=>[""],
               "contentBodyHeading5"=>["This is a heading."],
               "contentBodyHeading4"=>
                ["Human Rights in Ukraine. Information website of the Kharkiv Human Rights Protection Group"],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>[""],
               "contentBodyHeading1"=>
                ["Prime Minister Azarov to answer charges of discrimination in court"]}]}},
         {"groupValue"=>"http://khpg.org/en/index.php?do=print&id=1269350026",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"digest"=>"sha1:OMAKO5447VX7WC7NQASCWDCKOJAP5AMM",
               "filename"=>
                "ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "length"=>4559,
               "mimetype"=>"text/html",
               "originalUrl"=>
                "http://khpg.org/en/index.php?do=print&id=1269350026",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2010_09/ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904151955-01207-crawling04.us.archive.org-6682.warc.gz",
               "recordDate"=>"20100904153309",
               "recordIdentifier"=>
                "20100904153309/http://khpg.org/en/index.php?do=print&id=1269350026",
               "statusCode"=>"200",
               "dateOfCaptureYYYY"=>"2010",
               "dateOfCaptureYYYYMM"=>"201009",
               "dateOfCaptureYYYYMMDD"=>"20100904",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20100904153309/http://khpg.org/en/index.php?do=print&id=1269350026",
               "contentBody"=>
                "This is a doc.",
               "contentTitle"=>"",
               "timestamp"=>"2011-09-30T17:55:26.097Z",
               "contentBodyHeading6"=>[""],
               "contentBodyHeading5"=>["This is a heading."],
               "contentBodyHeading4"=>
                ["Human Rights in Ukraine. Information website of the Kharkiv Human Rights Protection Group"],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>[""],
               "contentBodyHeading1"=>
                ["Complaint to Human Rights Ombudsperson over Azarov'iscriminatory comments"]}]}},
         {"groupValue"=>"http://khpg.org/en/index.php?do=print&id=1269043679",
          "doclist"=>
           {"numFound"=>1,
            "start"=>0,
            "docs"=>
             [{"digest"=>"sha1:SKYAOLCCSCWA6PQVKT5DBXO6CAOIM5B3",
               "filename"=>
                "ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904153338-01208-crawling04.us.archive.org-6682.warc.gz",
               "length"=>2037,
               "mimetype"=>"text/html",
               "originalUrl"=>
                "http://khpg.org/en/index.php?do=print&id=1269043679",
               "readerIdentifier"=>
                "/cul/cul1/ldpd/mellon_web_resources_collection/human_rights/asf-indexer-qad/archive-it_copy/2010_09/ARCHIVEIT-1068-QUARTERLY-HUHLCT-20100904153338-01208-crawling04.us.archive.org-6682.warc.gz",
               "recordDate"=>"20100904153350",
               "recordIdentifier"=>
                "20100904153350/http://khpg.org/en/index.php?do=print&id=1269043679",
               "statusCode"=>"200",
               "dateOfCaptureYYYY"=>"2010",
               "dateOfCaptureYYYYMM"=>"201009",
               "dateOfCaptureYYYYMMDD"=>"20100904",
               "archivedUrl"=>
                "http://wayback.archive-it.org/1068/20100904153350/http://khpg.org/en/index.php?do=print&id=1269043679",
               "contentBody"=>
                "This is a doc.",
               "contentTitle"=>"",
               "timestamp"=>"2011-09-30T19:48:27.485Z",
               "contentBodyHeading6"=>[""],
               "contentBodyHeading5"=>["This is a heading."],
               "contentBodyHeading4"=>
                ["Human Rights in Ukraine. Information website of the Kharkiv Human Rights Protection Group"],
               "contentBodyHeading3"=>[""],
               "contentBodyHeading2"=>[""],
               "contentBodyHeading1"=>
                ["Azarov: Carrying out reform is not a woman'stter"]}]}}]}},
   "facet_counts"=>
    {"facet_queries"=>{},
     "facet_fields"=>
      {"domain"=>
        ["www.wluml.org",
         551111,
         "awid.org",
         88075,
         "www.asiapacificforum.net",
         29804,
         "www.omct.org",
         14120,
         "www.cdhr.info",
         7457,
         "www.nchregypt.org",
         6579,
         "www.amnesty.org",
         6101,
         "www.frontlinedefenders.org",
         6068,
         "www.we-change.org",
         5155,
         "www.equalityhumanrights.com",
         4629,
         "www.humanrights.asia",
         3881],
       "geographic_focus__facet"=>
        ["[Global focus]",
         676749,
         "Asia",
         34863,
         "Pacific Ocean",
         29804,
         "Egypt",
         8127,
         "Saudi Arabia",
         7472,
         "Iran",
         7208,
         "Great Britain",
         4630,
         " [043 CODE NOT FOUND IN MARC LIST]",
         3844,
         "Australia",
         3335,
         "Northern Ireland",
         3016,
         "Namibia",
         2995],
       "organization_based_in__facet"=>
        ["England",
         560698,
         "No place, unknown, or undetermined",
         86897,
         "Australia",
         33139,
         "Switzerland",
         17527,
         "United States",
         9285,
         "United Kingdom",
         8358,
         "Egypt",
         8207,
         "Ireland",
         6459,
         "Iran",
         5163,
         "New York (State)",
         3999,
         "China",
         3884],
       "organization_type__facet"=>
        ["Non-governmental organizations",
         755363,
         "National human rights institutions",
         19616,
         "Other organization types",
         1083,
         "Individual site creators",
         153],
       "language__facet"=>
        ["English",
         773972,
         "French",
         669939,
         "Arabic",
         573894,
         "Spanish",
         122628,
         "Russian",
         8803,
         "Persian",
         6683,
         "Hungarian",
         1265,
         "Turkish",
         834,
         "Georgian",
         761,
         "Ukrainian",
         538,
         "Italian",
         527],
       "contentMetaLanguage"=>
        ["en",
         4359,
         "english",
         208,
         "enus",
         27,
         "us",
         27,
         "es",
         14,
         "fr",
         13,
         "ar",
         12,
         "de",
         9,
         "sv",
         8,
         "el",
         4,
         "nl",
         4],
       "creator_name__facet"=>
        ["Women Living Under Muslim Laws (Organization)",
         551111,
         "Association for Women's Rights in Development",
         88075,
         "Asia Pacific Forum of National Human Rights Institutions",
         29804,
         "World Organisation Against Torture",
         14120,
         "Center for Democracy & Human Rights in Saudi Arabia",
         7457,
         "Majlis al-Qawmi li-Hqu al-Insa (Egypt)",
         6579,
         "Amnesty International. International Secretariat",
         6101,
         "Front Line (Organization)",
         6068,
         "One Million Signatures Demanding Changes to Discriminatory Laws (Campaign)",
         5155,
         "Great Britain. Equality and Human Rights Commission",
         4629,
         "Asian Human Rights Commission",
         3881],
       "mimetype"=>
        ["html",
         1064299,
         "text",
         1064299,
         "texthtml",
         1029194,
         "charset",
         1014509,
         "8",
         948794,
         "utf",
         948794,
         "charsetutf",
         913152,
         "0",
         49322,
         "texthtmlcharsetutf",
         34820,
         "charsetwindow",
         15531,
         "window",
         15531],
       "dateOfCaptureYYYY"=>["2011", 581788, "2010", 476491, "2009", 6195]},
     "facet_dates"=>{},
     "facet_ranges"=>{}}})
  end
  
  def create_mock_raw_response
    raw_response = eval(mock_query_response_grouped)
    return raw_response
  end

  def create_mock_rsolr_ext_response
    raw_response = create_mock_raw_response
    return RSolr::Ext::Response::Base.new( raw_response,
                                           'select',
                                           raw_response[ 'responseHeader' ][ 'params' ] )
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end
