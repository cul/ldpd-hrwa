require 'rsolr-ext'

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

def mock_query_response
  %({'responseHeader'=>{'status'=>0,'QTime'=>5,'params'=>{'facet.limit'=>'10','wt'=>'ruby','rows'=>'11','facet'=>'true','facet.field'=>['cat','manu'],'echoParams'=>'EXPLICIT','q'=>'*:*','facet.sort'=>'true'}},'response'=>{'numFound'=>26,'start'=>0,'docs'=>[{'id'=>'SP2514N','inStock'=>true,'manu'=>'Samsung Electronics Co. Ltd.','name'=>'Samsung SpinPoint P120 SP2514N - hard drive - 250 GB - ATA-133','popularity'=>6,'price'=>92.0,'sku'=>'SP2514N','timestamp'=>'2009-03-20T14:42:49.795Z','cat'=>['electronics','hard drive'],'spell'=>['Samsung SpinPoint P120 SP2514N - hard drive - 250 GB - ATA-133'],'features'=>['7200RPM, 8MB cache, IDE Ultra ATA-133','NoiseGuard, SilentSeek technology, Fluid Dynamic Bearing (FDB) motor']},{'id'=>'6H500F0','inStock'=>true,'manu'=>'Maxtor Corp.','name'=>'Maxtor DiamondMax 11 - hard drive - 500 GB - SATA-300','popularity'=>6,'price'=>350.0,'sku'=>'6H500F0','timestamp'=>'2009-03-20T14:42:49.877Z','cat'=>['electronics','hard drive'],'spell'=>['Maxtor DiamondMax 11 - hard drive - 500 GB - SATA-300'],'features'=>['SATA 3.0Gb/s, NCQ','8.5ms seek','16MB cache']},{'id'=>'F8V7067-APL-KIT','inStock'=>false,'manu'=>'Belkin','name'=>'Belkin Mobile Power Cord for iPod w/ Dock','popularity'=>1,'price'=>19.95,'sku'=>'F8V7067-APL-KIT','timestamp'=>'2009-03-20T14:42:49.937Z','weight'=>4.0,'cat'=>['electronics','connector'],'spell'=>['Belkin Mobile Power Cord for iPod w/ Dock'],'features'=>['car power adapter, white']},{'id'=>'IW-02','inStock'=>false,'manu'=>'Belkin','name'=>'iPod & iPod Mini USB 2.0 Cable','popularity'=>1,'price'=>11.5,'sku'=>'IW-02','timestamp'=>'2009-03-20T14:42:49.944Z','weight'=>2.0,'cat'=>['electronics','connector'],'spell'=>['iPod & iPod Mini USB 2.0 Cable'],'features'=>['car power adapter for iPod, white']},{'id'=>'MA147LL/A','inStock'=>true,'includes'=>'earbud headphones, USB cable','manu'=>'Apple Computer Inc.','name'=>'Apple 60 GB iPod with Video Playback Black','popularity'=>10,'price'=>399.0,'sku'=>'MA147LL/A','timestamp'=>'2009-03-20T14:42:49.962Z','weight'=>5.5,'cat'=>['electronics','music'],'spell'=>['Apple 60 GB iPod with Video Playback Black'],'features'=>['iTunes, Podcasts, Audiobooks','Stores up to 15,000 songs, 25,000 photos, or 150 hours of video','2.5-inch, 320x240 color TFT LCD display with LED backlight','Up to 20 hours of battery life','Plays AAC, MP3, WAV, AIFF, Audible, Apple Lossless, H.264 video','Notes, Calendar, Phone book, Hold button, Date display, Photo wallet, Built-in games, JPEG photo playback, Upgradeable firmware, USB 2.0 compatibility, Playback speed control, Rechargeable capability, Battery level indication']},{'id'=>'TWINX2048-3200PRO','inStock'=>true,'manu'=>'Corsair Microsystems Inc.','name'=>'CORSAIR  XMS 2GB (2 x 1GB) 184-Pin DDR SDRAM Unbuffered DDR 400 (PC 3200) Dual Channel Kit System Memory - Retail','popularity'=>5,'price'=>185.0,'sku'=>'TWINX2048-3200PRO','timestamp'=>'2009-03-20T14:42:49.99Z','cat'=>['electronics','memory'],'spell'=>['CORSAIR  XMS 2GB (2 x 1GB) 184-Pin DDR SDRAM Unbuffered DDR 400 (PC 3200) Dual Channel Kit System Memory - Retail'],'features'=>['CAS latency 2, 2-3-3-6 timing, 2.75v, unbuffered, heat-spreader']},{'id'=>'VS1GB400C3','inStock'=>true,'manu'=>'Corsair Microsystems Inc.','name'=>'CORSAIR ValueSelect 1GB 184-Pin DDR SDRAM Unbuffered DDR 400 (PC 3200) System Memory - Retail','popularity'=>7,'price'=>74.99,'sku'=>'VS1GB400C3','timestamp'=>'2009-03-20T14:42:50Z','cat'=>['electronics','memory'],'spell'=>['CORSAIR ValueSelect 1GB 184-Pin DDR SDRAM Unbuffered DDR 400 (PC 3200) System Memory - Retail']},{'id'=>'VDBDB1A16','inStock'=>true,'manu'=>'A-DATA Technology Inc.','name'=>'A-DATA V-Series 1GB 184-Pin DDR SDRAM Unbuffered DDR 400 (PC 3200) System Memory - OEM','popularity'=>5,'sku'=>'VDBDB1A16','timestamp'=>'2009-03-20T14:42:50.004Z','cat'=>['electronics','memory'],'spell'=>['A-DATA V-Series 1GB 184-Pin DDR SDRAM Unbuffered DDR 400 (PC 3200) System Memory - OEM'],'features'=>['CAS latency 3,  2.7v']},{'id'=>'3007WFP','inStock'=>true,'includes'=>'USB cable','manu'=>'Dell, Inc.','name'=>'Dell Widescreen UltraSharp 3007WFP','popularity'=>6,'price'=>2199.0,'sku'=>'3007WFP','timestamp'=>'2009-03-20T14:42:50.017Z','weight'=>401.6,'cat'=>['electronics','monitor'],'spell'=>['Dell Widescreen UltraSharp 3007WFP'],'features'=>['30" TFT active matrix LCD, 2560 x 1600, .25mm dot pitch, 700:1 contrast']},{'id'=>'VA902B','inStock'=>true,'manu'=>'ViewSonic Corp.','name'=>'ViewSonic VA902B - flat panel display - TFT - 19"','popularity'=>6,'price'=>279.95,'sku'=>'VA902B','timestamp'=>'2009-03-20T14:42:50.034Z','weight'=>190.4,'cat'=>['electronics','monitor'],'spell'=>['ViewSonic VA902B - flat panel display - TFT - 19"'],'features'=>['19" TFT active matrix LCD, 8ms response time, 1280 x 1024 native resolution']},{'id'=>'0579B002','inStock'=>true,'manu'=>'Canon Inc.','name'=>'Canon PIXMA MP500 All-In-One Photo Printer','popularity'=>6,'price'=>179.99,'sku'=>'0579B002','timestamp'=>'2009-03-20T14:42:50.062Z','weight'=>352.0,'cat'=>['electronics','multifunction printer','printer','scanner','copier'],'spell'=>['Canon PIXMA MP500 All-In-One Photo Printer'],'features'=>['Multifunction ink-jet color photo printer','Flatbed scanner, optical scan resolution of 1,200 x 2,400 dpi','2.5" color LCD preview screen','Duplex Copying','Printing speed up to 29ppm black, 19ppm color','Hi-Speed USB','memory card: CompactFlash, Micro Drive, SmartMedia, Memory Stick, Memory Stick Pro, SD Card, and MultiMediaCard']}]},'facet_counts'=>{'facet_queries'=>{},'facet_fields'=>{'cat'=>['electronics',14,'memory',3,'card',2,'connector',2,'drive',2,'graphics',2,'hard',2,'monitor',2,'search',2,'software',2],'manu'=>['inc',8,'apach',2,'belkin',2,'canon',2,'comput',2,'corp',2,'corsair',2,'foundat',2,'microsystem',2,'softwar',2]},'facet_dates'=>{}}})
end

def mock_query_response_for_count
  %({'responseHeader'=>{'status'=>0,'QTime'=>5,'params'=>{'facet.limit'=>'10','wt'=>'ruby','rows'=>'11','facet'=>'true','facet.field'=>['cat','manu'],'echoParams'=>'EXPLICIT','q'=>'*:*','facet.sort'=>'true'}},'response'=>{'numFound'=>26,'start'=>0,'docs'=>[]},'facet_counts'=>{'facet_queries'=>{},'facet_fields'=>{'cat'=>['electronics',14,'memory',3,'card',2,'connector',2,'drive',2,'graphics',2,'hard',2,'monitor',2,'search',2,'software',2],'manu'=>['inc',8,'apach',2,'belkin',2,'canon',2,'comput',2,'corp',2,'corsair',2,'foundat',2,'microsystem',2,'softwar',2]},'facet_dates'=>{}}})
end

# These spellcheck responses are all Solr 1.4 responses
def mock_response_with_spellcheck
  %|{'responseHeader'=>{'status'=>0,'QTime'=>9,'params'=>{'spellcheck'=>'true','spellcheck.collate'=>'true','wt'=>'ruby','q'=>'hell ultrashar'}},'response'=>{'numFound'=>0,'start'=>0,'docs'=>[]},'spellcheck'=>{'suggestions'=>['hell',{'numFound'=>1,'startOffset'=>0,'endOffset'=>4,'suggestion'=>['dell']},'ultrashar',{'numFound'=>1,'startOffset'=>5,'endOffset'=>14,'suggestion'=>['ultrasharp']},'collation','dell ultrasharp']}}|
end

def mock_response_with_spellcheck_extended
   %|{'responseHeader'=>{'status'=>0,'QTime'=>8,'params'=>{'spellcheck'=>'true','spellcheck.collate'=>'true','wt'=>'ruby','spellcheck.extendedResults'=>'true','q'=>'hell ultrashar'}},'response'=>{'numFound'=>0,'start'=>0,'docs'=>[]},'spellcheck'=>{'suggestions'=>['hell',{'numFound'=>1,'startOffset'=>0,'endOffset'=>4,'origFreq'=>0,'suggestion'=>[{'word'=>'dell','freq'=>1}]},'ultrashar',{'numFound'=>1,'startOffset'=>5,'endOffset'=>14,'origFreq'=>0,'suggestion'=>[{'word'=>'ultrasharp','freq'=>1}]},'correctlySpelled',false,'collation','dell ultrasharp']}}|
end

def mock_response_with_spellcheck_same_frequency
  %|{'responseHeader'=>{'status'=>0,'QTime'=>8,'params'=>{'spellcheck'=>'true','spellcheck.collate'=>'true','wt'=>'ruby','spellcheck.extendedResults'=>'true','q'=>'hell ultrashar'}},'response'=>{'numFound'=>0,'start'=>0,'docs'=>[]},'spellcheck'=>{'suggestions'=>['hell',{'numFound'=>1,'startOffset'=>0,'endOffset'=>4,'origFreq'=>1,'suggestion'=>[{'word'=>'dell','freq'=>1}]},'ultrashard',{'numFound'=>1,'startOffset'=>5,'endOffset'=>14,'origFreq'=>1,'suggestion'=>[{'word'=>'ultrasharp','freq'=>1}]},'correctlySpelled',false,'collation','dell ultrasharp']}}|
end

# it can be the case that extended results are off and collation is on
def mock_response_with_spellcheck_collation
  %|{'responseHeader'=>{'status'=>0,'QTime'=>3,'params'=>{'spellspellcheck.build'=>'true','spellcheck'=>'true','q'=>'hell','spellcheck.q'=>'hell ultrashar','wt'=>'ruby','spellcheck.collate'=>'true'}},'response'=>{'numFound'=>0,'start'=>0,'docs'=>[]},'spellcheck'=>{'suggestions'=>['hell',{'numFound'=>1,'startOffset'=>0,'endOffset'=>4,'suggestion'=>['dell']},'ultrashar',{'numFound'=>1,'startOffset'=>5,'endOffset'=>14,'suggestion'=>['ultrasharp']},'collation','dell ultrasharp']}}|
end


