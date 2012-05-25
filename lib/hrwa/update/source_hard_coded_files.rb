require 'rsolr'
require 'uri'

class HRWA::Update::SourceHardCodedFiles
	unloadable

	LOG_ENTRY_HEADER = '[UPDATE_SOURCE_HARD_CODED_FILES]'

  def initialize( browse_list_file,
                  filter_options_file,
                  solr_url = 'http://carter.cul.columbia.edu:8080/solr-4/fsf')

    @solr_url = solr_url
    
    # Configuration of components
    @update_params_for_component = {}

    # Data lists from SOLR fields needed to constrcut final lists
    @browse_list_data_for    = {}
    @filter_options_data_for = {}

    # Final lists
    @browse_list_for    = {}
    @filter_options_for = {}

    initialize_update_params_for_browse_list_component( browse_list_file )
    initialize_update_params_for_filter_options_component( filter_options_file )
  end

  def initialize_update_params_for_browse_list_component(
    browse_list_file = 'app/helpers/hrwa/collection_browse_lists_source_hardcoded.rb'
  )
    @update_params_for_component[ :browse_lists ] = 
      { :items_for               => @browse_list_for,
        :data_for                => @browse_list_data_for,
        :destination_file        => browse_list_file,
        :add_single_value_method => self.method( :add_single_value_to_browse_list_for ),
        :module_name             => 'HRWA::CollectionBrowseListsSourceHardcoded',
        :def_text_method         => self.method( :browse_list_method_def_text ),
        :special_cases_methods   => [ self.method( :title_browse_list_items ) ],
        :solr_fields_to_make_lists_from   => [
                   'creator_name',
                   'geographic_focus',
                   'language',
                   'organization_based_in',
                   'subject',
                 ], 
        :solr_fields_to_retrieve_for_data => [
                   'alternate_title',
                   'title',
                   'title__sort',
                 ],
      }
  end
  
  def initialize_update_params_for_filter_options_component(
    filter_options_file = 'app/helpers/hrwa/filter_options_source_hardcoded.rb'
  )
    @update_params_for_component[ :filter_options ] =
    { :items_for               => @filter_options_for,
      :data_for                => @filter_options_data_for,
      :destination_file        => filter_options_file,
      :add_single_value_method => self.method( :add_single_value_to_filter_options_for ),
      :module_name             => 'HRWA::FilterOptionsSourceHardcoded',
      :def_text_method         => self.method( :filter_options_method_def_text ),
      :special_cases_methods   => [ self.method( :domain_filter_options ), self.method( :title_filter_options ) ],
      :solr_fields_to_make_lists_from   => [
                 'creator_name',
                 'geographic_focus',
                 'language',
                 'organization_based_in',
                 'organization_type',
                 'subject',
               ],
      :solr_fields_to_retrieve_for_data => [
                 'alternate_title',
                 'original_urls',
                 'title',
                 'title__sort',
               ],
    }
  end

  def update_rails_file( component )
    if ! @update_params_for_component.has_key?( component.to_sym )
      message = %Q{"#{ component }" is not a valid component.  Valid components:
				#{ @update_params_for_component.keys.sort.join( ', ' ) } }
      raise ArgumentError, message
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

    Rails.logger.info( LOG_ENTRY_HEADER + " Updated #{ params[ :destination_file ] }" )
  end

  def fetch_items( component, params )
    begin
      solr_fields = params[ :solr_fields_to_make_lists_from ] + params[ :solr_fields_to_retrieve_for_data ]
      docs = fetch( solr_fields )
    rescue UpdateException => e
      Rails.logger.error LOG_ENTRY_HEADER + " fetch_items() for #{ component } failed"
      Rails.logger.error LOG_ENTRY_HEADER + ' ' + e
      Rails.logger.error LOG_ENTRY_HEADER + ' ' + @response.pretty_inspect
      raise e
    end

    message = "fetch() retrieved #{ docs.length } docs"
    Rails.logger.info( LOG_ENTRY_HEADER + ' ' + message )

    list_fields                    = params[ :solr_fields_to_make_lists_from ]
    data_fields_not_used_for_lists = params[ :solr_fields_to_retrieve_for_data ]
    data_fields_not_used_for_lists.each { | field |
      params[ :data_for ][ field ] = []
    }
    docs.each { |doc|
      # Data to be used for complex special cases
      data_fields_not_used_for_lists.each { | field |
        if doc[ field ]
          if doc[ field ].is_a?( Array )
            doc[ field ].each { | value |
              params[ :data_for ][ field ] << value
            }
          else
              params[ :data_for ][ field ] << doc[ field ]
          end
        end
      }
      # Final lists
      list_fields.each { | field |
        value = doc[ field ]
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

#############################################

# Methods for constructing complex special cases

  def domain_filter_options
    original_urls = @filter_options_data_for[ 'original_urls' ]

    # Start method def
    method_def_text = ''
    method_def_text << "  def domain_filter_options\n"
    method_def_text << "    return [\n"

    hoststrings = original_urls.each.map { | url |
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

  def title_browse_list_items    
    title_items( @browse_list_data_for[ 'title'],
                 @browse_list_data_for[ 'title__sort'],
                 'title_browse_list_items' )
  end

  def title_filter_options
    title_items( @filter_options_data_for[ 'title'],
                 @browse_list_data_for[ 'title__sort'],
                 'title_filter_options' )
  end
  
  def title_items( titles, title_sort_values, method_name )
    
    puts "titles.length = #{ titles.length }"
    puts "title_sort_values.length = #{ title_sort_values.length }"
    
    # Start method def
    method_def_text = ''
    method_def_text << "  def #{ method_name }\n"
    method_def_text << "    return {\n"

    title_sort_values_iterator = title_sort_values.to_enum
    titles.each { | title |
      title_sort_value = title_sort_values_iterator.next
      method_def_text << "              %q{#{ title }} => '#{ title_sort_value }',\n"
    }

    # Close method def
    method_def_text << "           }\n\n"
    method_def_text << "  end\n"

    return method_def_text
  end


end

class UpdateException < Exception
end
