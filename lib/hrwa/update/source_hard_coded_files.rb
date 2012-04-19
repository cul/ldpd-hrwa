require 'rsolr'
require 'uri'

class HRWA::Update::SourceHardCodedFiles
	unloadable

  def initialize( browse_list_file =  'app/helpers/hrwa/collection_browse_lists_source_hardcoded.rb',
                  filter_options_file = 'app/helpers/hrwa/filter_options_source_hardcoded.rb',
                  solr_url = 'http://carter.cul.columbia.edu:8080/solr-4/fsf')

    @browse_list_for    = {}
    @filter_options_for = {}

    @solr_url = solr_url

    @update_params_for_component = {
      :browse_lists   =>
        { :items_for               => @browse_list_for,
          :destination_file        => browse_list_file,
          :add_single_value_method => self.method( :add_single_value_to_browse_list_for ),
          :module_name             => 'HRWA::CollectionBrowseListsSourceHardcoded',
          :def_text_method         => self.method( :browse_list_method_def_text ),
          :special_cases_methods   => nil,
          :solr_fields             => [
                     'alternate_title',
                     'creator_name',
                     'geographic_focus',
                     'language',
                     'organization_based_in',
                     'organization_type',
                     'original_urls',
                     'subject',
                     'title',
                   ],
                         },
      :filter_options =>
        { :items_for               => @filter_options_for,
          :destination_file        => filter_options_file,
          :add_single_value_method => self.method( :add_single_value_to_filter_options_for ),
          :module_name             => 'HRWA::FilterOptionsSourceHardcoded',
          :def_text_method         => self.method( :filter_options_method_def_text ),
          :special_cases_methods   => [ self.method( :domain_filter_options ) ],
          :solr_fields             => [
                     'creator_name',
                     'geographic_focus',
                     'language',
                     'organization_based_in',
                     'organization_type',
                     'original_urls',
                     'subject',
                     'title',
                   ],
                         },
    }

    @browse_list_solr_fields = [
                     'alternate_title',
                     'creator_name',
                     'geographic_focus',
                     'language',
                     'organization_based_in',
                     'organization_type',
                     'original_urls',
                     'subject',
                     'title',
                   ]

    @filter_options_solr_fields = [
                     'creator_name',
                     'geographic_focus',
                     'language',
                     'organization_based_in',
                     'organization_type',
                     'original_urls',
                     'subject',
                     'title',
                   ]

  end

  def update_rails_file( component )
    if ! @update_params_for_component.has_key?( component.to_sym )
      puts %Q{"#{ component }" is not a valid component.  Please choose from the following:}
      puts "#{ @update_params_for_component.keys.sort.join( ', ' ) }"
      return
    end

    params = @update_params_for_component[ component ]
    fetch_items( component, params )

    File.open( params[ :destination_file ], 'w' ) { | f |
      f.puts %q{# -*- encoding : utf-8 -*-}
      f.puts %Q{module #{ params[ :module_name ] }}

      params[ :items_for ].keys.sort.each { | category |
        f.puts params[ :def_text_method ].call( category )
        f.puts
      }

      if params[ :special_cases_methods ]
        params[ :special_cases_methods ].each { | m |
          f.puts m.call
        }
      end

      f.puts %q{end}
    }

    puts "updated #{ params[ :destination_file ] }"
  end

  def fetch_items( component, params )
    begin
      docs = fetch( params[ :solr_fields ] )
    rescue UpdateException => e
      puts "fetch_items: fetch() error: #{ e }"

      Rails.logger.error "fetch_items() for #{ component } failed"
      Rails.logger.error e
      Rails.logger.error @response.pretty_inspect
      raise e
    end

    message = "fetch() retrieved #{ docs.length } docs"
    Rails.logger.info( message )

    docs.each { |doc|
      doc.each_pair { | field, value |
        # @browse_list_for is a hash of hashes
        # Top-level keys is the name of the SOLR field used as a browse category
        # Each of the keys in the nested hashes are values in the category, which
        # map to counts of how many sites fall under that category value
        add_to_items_for( params[ :add_single_value_method ], field, value )
      }
    }
  end

  def fetch( solr_fields )
    @solr = RSolr.connect :url => @solr_url

    @response = @solr.get 'select',
                          :params => {
                            :q  => '*:*',
                            :fl => solr_fields.join( ',' ),
                            :rows => 99999,
                          }

    status = @response['responseHeader']['status']

    if status != 0
      raise UpdateException, "SOLR server returned non-zero status code: #{status}" if status != 0
    end

    return @response[ 'response' ][ 'docs' ]
  end

  def add_to_items_for( add_method, field, value )
    if value.is_a?( Array )
      value.each { | single_value | add_method.call( field, single_value ) }
    else
      add_method.call( field, value )
    end
  end

  def add_single_value_to_browse_list_for( field, value )
    # If browse list already exists, increment the count for the value or
    # initialize it if the value hasn't been encountered yet
    if @browse_list_for[ field.to_sym ]
      if @browse_list_for[ field.to_sym ][ value.to_sym ]
        @browse_list_for[ field.to_sym ][ value.to_sym ] += 1
      else
        @browse_list_for[ field.to_sym ][ value.to_sym ] = 1
      end

    # If the browse list doesn't already exist, create it and initialize
    # the count for the value
    else
      @browse_list_for[ field.to_sym ] = { value.to_sym => 1 }
    end
  end

  def add_single_value_to_filter_options_for( field, value )
    if @filter_options_for[ field.to_sym ]
      if @filter_options_for[ field.to_sym ][ value.to_sym ]
        return
      else
        @filter_options_for[ field.to_sym ][ value.to_sym ] = 1
      end
    else
      @filter_options_for[ field.to_sym ] = { value.to_sym => 1 }
    end
  end

  def domain_filter_options
    original_urls = @filter_options_for[ :original_urls ]

    # Start method def
    method_def_text = ''
    method_def_text << "  def domain_filter_options\n"
    method_def_text << "    return [\n"

    hoststrings = original_urls.keys.map { | url |
      domain     = url.to_s.match( %r{ \A https?:// (?<domain> [^/]+ ) .* \Z }x )[ :domain ]
      hoststring = domain.sub( %r{ \A www [\w]? \. }x, '' )
      hoststring
    }

    hoststrings.sort { | a, b | a.casecmp( b ) }.each { | hoststring |
      method_def_text << "              %q{#{ hoststring }},\n"
    }

    # Close method def
    method_def_text << "           ]\n"
    method_def_text << "  end\n"

    return method_def_text
  end

  def browse_list_method_def_text( category )
    # Start method def
    method_def_text = ''
    method_def_text << "  def #{ category }_browse_list_items\n"
    method_def_text << "    return {\n"

    @browse_list_for[ category ].sort_by { | k, v | v }.reverse.each { | item, count |
      method_def_text << "              %q{#{ item }} => #{ count },\n"
    }

    # Close method def
    method_def_text << "           }\n"
    method_def_text << "  end\n"

    return method_def_text

  end

  def filter_options_method_def_text( category )
    # Start method def
    method_def_text = ''
    method_def_text << "  def #{ category }_filter_options\n"
    method_def_text << "    return [\n"

    @filter_options_for[ category ].keys.sort { | a, b | a.casecmp( b ) }.each { | item |
      method_def_text << "              %q{#{ item }},\n"
    }

    # Close method def
    method_def_text << "           ]\n"
    method_def_text << "  end\n"

    return method_def_text

  end

end

class UpdateException < Exception
end
