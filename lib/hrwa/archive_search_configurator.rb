# -*- encoding : utf-8 -*-
class HRWA::ArchiveSearchConfigurator
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
                               'contentBody',
                               'contentTitle',
                               'originalUrl',
                               ],
          :'hl.usePhraseHighlighter' => true,
          :'hl.simple.pre'  => '<code>',
          :'hl.simple.post' => '</code>',
          :'q.alt'          => '*:*',
          :qf               => [
                                'contentBody^1',
                                'contentTitle^1',
                                'originalUrl^1',
                               ],
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

        config.add_facet_field 'dateOfCaptureYYYY',
                               :label => 'Date Of Capture',
                               :limit => 5

        config.add_facet_field 'domain',
                               :label => 'Domain',
                               :limit => 5

        config.add_facet_field 'geographic_focus__facet',
                               :label => 'Geographic Focus',
                               :limit => 5

        config.add_facet_field 'organization_based_in__facet',
                               :label => 'Organization Based In',
                               :limit => 5

        config.add_facet_field 'organization_type__facet',
                               :label => 'Organization Type',
                               :limit => 5

        config.add_facet_field 'language__facet',
                               :label => 'Website Language',
                               :limit => 5

        config.add_facet_field 'creator_name__facet',
                               :label => 'Creator',
                               :limit => 5

        config.add_facet_field 'mimetype',
                               :label => 'File Type',
                               :limit => 5

        # Have BL send all facet field names to Solr, which has been the default
        # previously. Simply remove these lines if you'd rather use Solr request
        # handler defaults, or have no facets.
        config.default_solr_params[:'facet.field'] = config.facet_fields.keys

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

  def add_capture_date_range_fq_to_solr( solr_parameters, user_params = params )
      # We are going to assume that the capture date params are non-nil from this
      # point onward
      # Get range endpoints, using * for open-ended wildcard
      capture_start_date = ! ( user_params[ :capture_start_date ].nil? || user_params[ :capture_start_date ].empty? ) ?
                           user_params[ :capture_start_date ] :
                           '*'
      capture_end_date   = ! ( user_params[ :capture_end_date ].nil? || user_params[ :capture_end_date ].empty? ) ?
                           user_params[ :capture_end_date ] :
                           '*'

      return if ( capture_start_date == '*' && capture_end_date == '*' )

      #Convert capture_start_date and capture_end_date from YYYY-MM format to YYYYMM (as needed)
      if (capture_start_date != '*')
        capture_start_date = capture_start_date.gsub('-', '')
      end
      if (capture_end_date != '*')
        capture_end_date = capture_end_date.gsub('-', '')
      end

      solr_parameters[ :fq ] ||= []
      # Remove any existing capture date range filter
      # debugger
      solr_parameters[ :fq ].delete_if { | param | param =~ /^dateOfCaptureYYYYMM/ }

      solr_parameters[ :fq ] << "dateOfCaptureYYYYMM:[ #{ capture_start_date } TO #{ capture_end_date } ]"
    end

  def add_exclude_fq_to_solr( solr_parameters, user_params = params )
     # :fq, map from :excl_domain.
    if ( user_params[ :'excl_domain' ] )
      exclude_domain_request_params = user_params[ :'excl_domain' ]

      solr_parameters[ :fq ] ||= []
      # Remove any existing exclude domain filter
      solr_parameters[ :fq ].delete_if { | param | param =~ /^-domain/ }

      exclude_domain_request_params.each do | value_list |
        value_list ||= []
        value_list = [ value_list ] unless value_list.respond_to? :each
        value_list.each do | value |
          solr_parameters[ :fq ] << exclude_value_to_fq_string( 'domain', value )
        end
      end
    end
  end

  ##
  # Convert a field/value pair into a solr fq parameter
  def exclude_value_to_fq_string( exclude_field, value)
    case
      when (value.is_a?(Integer) or (value.to_i.to_s == value if value.respond_to? :to_i))
        "-#{exclude_field}:#{value}"
      when (value.is_a?(Float) or (value.to_f.to_s == value if value.respond_to? :to_f))
        "-#{exclude_field}:#{value}"
      when value.is_a?(Range)
        "-#{exclude_field}:[#{value.first} TO #{value.last}]"
      else
        "-#{ exclude_field}:#{ value }"
    end
  end

  def configure_facet_action( blacklight_config )
    # The SOLR group* params break Blacklight's faceting
    blacklight_config.default_solr_params.delete_if { | key, value |
      key.to_s.starts_with?( 'group' ) }
  end

  def name
    return 'archive'
  end

  # Do more with the SOLR response and results list that Blacklight
  # gives us.
  def post_blacklight_processing( solr_response, result_list )
    result_list = solr_response.groups
    return solr_response, result_list
  end

  # Did Blacklight give us everything we need in SOLR response and
  # results list objects?
  def post_blacklight_processing_required?
    return true
  end

  def process_search_request( solr_parameters, user_params = params )
   add_capture_date_range_fq_to_solr( solr_parameters, user_params )
   add_exclude_fq_to_solr( solr_parameters, user_params )
   set_solr_field_boost_levels( solr_parameters, user_params )
  end

  def prioritized_highlight_field_list
    return [
            'originalUrl',
            'contentTitle',
            'contentBody',
            ]
  end

  def result_partial
    return result_type
  end

  def result_type
    return 'group'
  end

  def set_solr_field_boost_levels( solr_parameters, user_params )
    return if ! user_params.has_key?( :field )

    valid_solr_fields = [ 'contentBody', 'contentTitle', 'originalUrl', ]

    qf = []
    user_params[ :field ].each { | field_boost |
      field, boost_level = field_boost.split( /\^/ )

      # Raise error if boost_level is not a positive number
      if ! ( boost_level.match( /^\d+$/ ) && boost_level.to_f > 0.0 ) then
        raise ArgumentError.new( "#{ boost_level } is not a valid boost level." )
      end

      if valid_solr_fields.include?( field ) then
        qf << "#{ field }^#{ boost_level }"
      end
    }

    # Overwrite existing qf
    solr_parameters[ :qf ] = qf
  end

  # Takes optional environment arg for testability
  def solr_url(localized_params = params, environment = Rails.env)
    if( !localized_params[:hrwa_host].blank? )
      YAML.load_file( 'config/solr.yml' )[ environment ][ 'asf' ][ 'url' ]
		else
      if localized_params[:hrwa_host] == 'dev'
        'http://carter.cul.columbia.edu:8080/solr-4/asf'
      elsif localized_params[:hrwa_host] == 'test'
				'http://harding.cul.columbia.edu:8080/solr-4/asf'
			elsif localized_params[:hrwa_host] == 'prod'
				'http://machete.cul.columbia.edu:8080/solr-4/asf'
			end
    end
  end

end
