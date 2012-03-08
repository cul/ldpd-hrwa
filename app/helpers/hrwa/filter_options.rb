# -*- encoding : utf-8 -*-
module HRWA::FilterOptions
  include HRWA::FilterOptionsSourceHardcoded
  # TODO: make all options html_safe
  def option_list( option_name, opts = { :selected => nil } )

    begin
      option_list = self.send( option_name + '_filter_options' )
    rescue NoMethodError
      raise ArgumentError, "No such filter option as #{ option_name }"
    end

    option_hash = option_list_to_hash( option_list )

    # Early return of full set of unselected options if no selected values are passed
    return option_hash if ( opts.nil? || opts[ :selected ].nil? )

    opts[ :selected ].each { | selected_value |
      if option_hash.has_key?( selected_value )
        Rails.logger.debug(selected_value + ' is selected!!!!!!!!!!!!!!!!!!!!')
        option_hash[ selected_value ] = true
      end
    }

    return option_hash
  end

  def option_list_to_hash( option_list )
    option_hash = {}
    option_list.sort.each { | option |
      option_hash[ option ] = false
    }
    return option_hash
  end

  def creator_name_options( opts = { :selected => nil } )
    return option_list( 'creator_name', opts )
  end

  def domain_options( opts = { :selected => nil } )
    return option_list( 'domain', opts )
  end

  def geographic_focus_options( opts = { :selected => nil } )
    return option_list( 'geographic_focus', opts )
  end

  def language_options( opts = { :selected => nil } )
    return option_list( 'language', opts )
  end

  def organization_based_in_options( opts = { :selected => nil } )
    return option_list( 'organization_based_in', opts )
  end

  def organization_type_options( opts = { :selected => nil } )
    return option_list( 'organization_type', opts )
  end

  def original_urls_options( opts = { :selected => nil } )
    return option_list( 'original_urls', opts )
  end

  def subject_options( opts = { :selected => nil } )
    return option_list( 'subject', opts )
  end

  def title_options( opts = { :selected => nil } )
    return option_list( 'title', opts )
  end

end
