# -*- encoding : utf-8 -*-
class Hrwa::SiteDetailConfigurator
  unloadable

  @@solr_url = nil;

  def config_proc
      return Proc.new { |config|
        config.default_solr_params = {
          :defType          => "edismax",
          :facet            => true,
          :'facet.mincount' => 1,
          :hl               => true,
          :'hl.fragsize'    => 400,
          :'hl.fl'          => [
                                "alternate_title",
                                "creator_name",
                                "geographic_focus",
                                "language",
                                "organization_based_in",
                                "original_urls",
                                "summary",
                                "title",
                               ],
          :'hl.usePhraseHighlighter' => true,
          :'hl.simple.pre'  => '<code>',
          :'hl.simple.post' => '</code>',
          :'q.alt'          => "*:*",
          :qf               => [
                                "alternate_title^1",
                                "creator_name^1",
                                "geographic_focus^1",
                                "language^1",
                                "organization_based_in^1",
                                "original_urls^1",
                                "summary^1",
                                "title^1",
                                ],
          :rows             => self.default_num_rows,
        }

        config.document_solr_request_handler = 'document'

        config.unique_key = "id"

        # solr field configuration for search results/index views
        config.index.show_link = 'title'
        config.index.record_display_type = ''

        # Our custom views make the config.show options useless
        # solr field configuration for document/show views
        #config.show.html_title   = 'title'
        #config.show.heading      = 'title'
        #config.show.display_type = ''

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

        config.add_facet_field 'geographic_focus__facet',
                               :label => 'Geographic Focus',
                               :limit => 5

        config.add_facet_field 'language__facet',
                               :label => 'Language',
                               :limit => 5

        config.add_facet_field 'organization_based_in__facet',
                               :label => 'Organization Based In',
                               :limit => 5

        config.add_facet_field 'organization_type__facet',
                               :label => 'Organization Type',
                               :limit => 5

        config.add_facet_field 'subject__facet',
                               :label => 'Subject',
                               :limit => 5

        # Have BL send all facet field names to Solr, which has been the default
        # previously. Simply remove these lines if you'd rather use Solr request
        # handler defaults, or have no facets.
        config.default_solr_params[:'facet.field'] = config.facet_fields.keys

        # solr fields to be displayed in the index (search results) view
        #   The ordering of the field names would normally be the order of the
        #   display, but we have our own custom layout so that doesn't really
        #   matter anymore.
        #config.add_index_field 'alternate_title', :label => 'Alternate Title:'              #multivalued
        #config.add_index_field 'archived_urls', :label => 'Archived URLs:'                  #multivalued
        #config.add_index_field 'geographic_focus', :label => 'Geographic Focus:'            #multivalued
        #config.add_index_field 'geographic_focus__facet', :label => 'Geographic Focus:'     #multivalued
        #config.add_index_field 'language', :label => 'Language:'                            #multivalued
        #config.add_index_field 'language__facet', :label => 'Language:'                     #multivalued
        #config.add_index_field 'organization_type', :label => 'Organization Type:'
        #config.add_index_field 'organization_type__facet', :label => 'Organization Type:'
        #config.add_index_field 'original_urls', :label => 'Original URLs:'                  #multivalued
        #config.add_index_field 'subject', :label => 'Subject:'                              #multivalued
        #config.add_index_field 'subject__facet', :label => 'Subject:'                       #multivalued
        #config.add_index_field 'summary', :label => 'Summary:'
        #config.add_index_field 'title', :label => 'Title:'

        #config.add_index_field 'title_vern_display', :label => 'Title:'
        #config.add_index_field 'author_display', :label => 'Author:'
        #config.add_index_field 'author_vern_display', :label => 'Author:'
        #config.add_index_field 'format', :label => 'Format:'
        #config.add_index_field 'language_facet', :label => 'Language:'
        #config.add_index_field 'published_display', :label => 'Published:'
        #config.add_index_field 'published_vern_display', :label => 'Published:'
        #config.add_index_field 'lc_callnum_display', :label => 'Call number:'

        # solr fields to be displayed in the show (single result) view
        #   The ordering of the field names is the order of the display
        # config.add_show_field 'title', :label => 'Title:'
        #config.add_show_field 'title_vern_display', :label => 'Title:'
        #config.add_show_field 'subtitle_display', :label => 'Subtitle:'
        #config.add_show_field 'subtitle_vern_display', :label => 'Subtitle:'
        #config.add_show_field 'author_display', :label => 'Author:'
        #config.add_show_field 'author_vern_display', :label => 'Author:'
        #config.add_show_field 'format', :label => 'Format:'
        #config.add_show_field 'url_fulltext_display', :label => 'URL:'
        #config.add_show_field 'url_suppl_display', :label => 'More Information:'
        #config.add_show_field 'language_facet', :label => 'Language:'
        #config.add_show_field 'published_display', :label => 'Published:'
        #config.add_show_field 'published_vern_display', :label => 'Published:'
        #config.add_show_field 'lc_callnum_display', :label => 'Call number:'
        #config.add_show_field 'isbn_t', :label => 'ISBN:'

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
        config.add_sort_field 'score desc', :label => 'relevance'

        # If there are more than this many search results, no spelling ("did you
        # mean") suggestion is offered.
        config.spell_max = 5
      }
    end

    def configure_facet_action( blacklight_config )
    end

    def result_partial
      return result_type
    end

    def result_type
      return 'document'
    end

    def default_num_rows
      return 1
    end

    # Takes optional environment arg for testability
    def self.solr_url(environment = Rails.env)

      @@solr_url ||= YAML.load_file( 'config/solr.yml' )[ environment ][ 'site_detail' ][ 'url' ]
      return @@solr_url

    end

    # Clear the current (class cached) value of @@solr_url
    def self.reset_solr_config
      @@solr_url = nil
    end

		# Set a new solr url for this configurator
		def self.override_solr_url(new_solr_yaml)
      @@solr_url = new_solr_yaml['site_detail']['url']
    end

    # Did Blacklight give us everything we need in SOLR response and
    # results list objects?
    def post_blacklight_processing_required?
      return false
    end

    def prioritized_highlight_field_list
      return [
              "title",
              "alternate_title",
              "creator_name",
              "geographic_focus",
              "language",
              "organization_based_in",
              "original_urls",
              "summary",
             ]
    end

    def process_search_request( extra_controller_params, params )
    end

    def name
      return 'site_detail'
    end

end
