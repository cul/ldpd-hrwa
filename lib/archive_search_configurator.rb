# -*- encoding : utf-8 -*-
class ArchiveSearchConfigurator
  unloadable

  def config_proc
      return Proc.new { |config|
        config.default_solr_params = {
          :defType          => 'dismax',
          :facet            => true,
          :'facet.mincount' => 1,
          :group            => true,
          :'group.field'    => 'originalUrl',
          :'group.limit'    => 10, 
          :hl               => true,
          :'hl.fragsize'    => 1000,
          :'hl.fl'          => [ 
                               'originalUrl',
                               'contentTitle',
                               'contentBody',
                               'contentMetaDescription',
                               'contentMetaKeywords',
                               'contentMetaLanguage',
                               'contentBodyHeading1',
                               'contentBodyHeading2',
                               'contentBodyHeading3',
                               'contentBodyHeading4',
                               'contentBodyHeading5',
                               'contentBodyHeading6',
                               ],
          :'hl.usePhraseHighlighter' => true,
          :'hl.simple.pre'  => '',
          :'hl.simple.post' => '',
          :'q.alt'          => '*:*',
          :qf               => ['contentTitle^1',
                                'contentBody^1',
                                'contentMetaDescription^1',
                                'contentMetaKeywords^1',
                                'contentMetaLanguage^1',
                                'contentBodyHeading1^1',
                                'contentBodyHeading2^1',
                                'contentBodyHeading3^1',
                                'contentBodyHeading4^1',
                                'contentBodyHeading5^1',
                                'contentBodyHeading6^1'],
          :rows             => 10,          
        }

        config.unique_key = 'recordIdentifier'

        # solr field configuration for search results/index views
        config.index.show_link           = 'contentTitle'
        config.index.record_display_type = ''

        # solr field configuration for document/show views
        config.show.html_title   = 'contentTitle'
        config.show.heading      = 'contentTitle'
        config.show.display_type = ''

        # solr fields that will be treated as facets by the blacklight application
        #   The ordering of the field names is the order of the display
        #
        # Setting a limit will trigger Blacklight's 'more' facet values link.
        # * If left unset, then all facet values returned by solr will be displayed.
        # * If set to an integer, then "f.somefield.facet.limit" will be added to
        # solr request, with actual solr request being +1 your configured limit --
        # you configure the number of items you actually want _displayed_ in a page.
        # * If set to 'true', then no additional parameters will be sent to solr,
        # but any 'sniffed' request limit parameters will be used for paging, with
        # paging at requested limit -1. Can sniff from facet.limit or
        # f.specific_field.facet.limit solr request params. This 'true' config
        # can be used if you set limits in :default_solr_params, or as defaults
        # on the solr side in the request handler itself. Request handler defaults
        # sniffing requires solr requests to be made with "echoParams=all", for
        # app code to actually have it echo'd back to see it.
        config.add_facet_field 'domain',
                               :label => 'Domain',
                               :limit => 10

        config.add_facet_field 'geographic_focus__facet',
                               :label => 'Organization/Site Geographic Focus',
                               :limit => 10

        config.add_facet_field 'organization_based_in__facet',
                               :label => 'Organization/Site Based In',
                               :limit => 10

        config.add_facet_field 'organization_type__facet',
                               :label => 'Organization Type',
                               :limit => 10

        config.add_facet_field 'language__facet',
                               :label => 'Website Language',
                               :limit => 10

        config.add_facet_field 'contentMetaLanguage',
                               :label => 'Language of page',
                               :limit => 10

        config.add_facet_field 'creator_name__facet',
                               :label => 'Creator Name',
                               :limit => 10

        config.add_facet_field 'mimetype',
                               :label => 'File Type',
                               :limit => 10

        config.add_facet_field 'dateOfCaptureYYYY',
                               :label => 'Year of Capture',
                               :limit => 10


        # Have BL send all facet field names to Solr, which has been the default
        # previously. Simply remove these lines if you'd rather use Solr request
        # handler defaults, or have no facets.
        config.default_solr_params[:'facet.field'] = config.facet_fields.keys

        # solr fields to be displayed in the index (search results) view
        #   The ordering of the field names is the order of the display
        config.add_index_field 'contentTitle', :label => 'Title:'
        config.add_index_field 'contentBody',  :label => 'Body:'

        # solr fields to be displayed in the show (single result) view
        #   The ordering of the field names is the order of the display
        config.add_show_field 'contentTitle', :label => 'Title:'

        # "fielded" search configuration. Used by pulldown among other places.
        # For supported keys in hash, see rdoc for Blacklight::SearchFields
        #
        # Search fields will inherit the :qt solr request handler from
        # config[:default_solr_parameters], OR can specify a different one
        # with a :qt key/value. Below examples inherit, except for subject
        # that specifies the same :qt as default for our own internal
        # testing purposes.
        #
        # The :key is what will be used to identify this BL search field internally,
        # as well as in URLs -- so changing it after deployment may break bookmarked
        # urls.  A display label will be automatically calculated from the :key,
        # or can be specified manually to be different.

        # This one uses all the defaults set by the solr request handler. Which
        # solr request handler? The one set in config[:default_solr_parameters][:qt],
        # since we aren't specifying it otherwise.

        # config.add_search_field 'all_fields', :label => 'All Fields'


        # Now we see how to over-ride Solr request handler defaults, in this
        # case for a BL "search field", which is really a dismax aggregate
        # of Solr search fields.

        #config.add_search_field('title') do |field|
          ## solr_parameters hash are sent to Solr as ordinary url query params.
          #field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

          ## :solr_local_parameters will be sent using Solr LocalParams
          ## syntax, as eg {! qf=$title_qf }. This is neccesary to use
          ## Solr parameter de-referencing like $title_qf.
          ## See: http://wiki.apache.org/solr/LocalParams
          #field.solr_local_parameters = {
            #:qf => '$title_qf',
            #:pf => '$title_pf'
          #}
        #end

        #config.add_search_field('author') do |field|
          #field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
          #field.solr_local_parameters = {
            #:qf => '$author_qf',
            #:pf => '$author_pf'
          #}
        #end

        ## Specifying a :qt only to show it's possible, and so our internal automated
        ## tests can test it. In this case it's the same as
        ## config[:default_solr_parameters][:qt], so isn't actually neccesary.
        #config.add_search_field('subject') do |field|
          #field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
          #field.qt = 'search'
          #field.solr_local_parameters = {
            #:qf => '$subject_qf',
            #:pf => '$subject_pf'
          #}
        #end

        # "sort results by" select (pulldown)
        # label in pulldown is followed by the name of the SOLR field to sort by and
        # whether the sort is ascending or descending (it must be asc or desc
        # except in the relevancy case).
        config.add_sort_field 'score desc, dateOfCaptureYYYYMMDD desc', :label => 'relevance'

        # If there are more than this many search results, no spelling ("did you
        # mean") suggestion is offered.
        config.spell_max = 5
      }
    end
    
    # Did Blacklight give us everything we need in SOLR response and
    # results list objects?
    def post_blacklight_processing_required?
      return true
    end
  
    # Do more with the SOLR response and results list that Blacklight
    # gives us.
    def post_blacklight_processing( solr_response, result_list )
      result_list = solr_response.groups
      return solr_response, result_list
    end
    
    def result_partial
      return result_type
    end

    def result_type
      return 'group'
    end
    
    def solr_url
      YAML.load_file("config/solr.yml")['development_asf']['url']
    end

end
