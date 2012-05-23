module HRWA::CollectionBrowseLists
  include HRWA::CollectionBrowseListsSourceHardcoded

  def creator_name_browse_list
    return browse_list( 'creator_name' )
  end

  def domain_browse_list
    return browse_list( 'domain' )
  end

  def geographic_focus_browse_list
    return browse_list( 'geographic_focus' )
  end

  def language_browse_list
    return browse_list( 'language' )
  end

  def organization_based_in_browse_list
    return browse_list( 'organization_based_in' )
  end

  def organization_type_browse_list
    return browse_list( 'organization_type' )
  end

  def original_urls_browse_list
    return browse_list( 'original_urls' )
  end

  def subject_browse_list
    return browse_list( 'subject' )
  end

  def title_browse_list
    return browse_list( 'title' )
  end

  # TODO: make all options html_safe
  def browse_list( browse_category_name )

    begin
      browse_list_hash = self.send( browse_category_name + '_browse_list_items' )
    rescue NoMethodError
      raise ArgumentError, "No such browse category as #{ browse_category_name }"
    end

    return browse_list_hash
  end

  def load_browse_lists( browse_lists_file = 'helpers/hrwa/collection_browse_lists_source_hardcoded.rb' )
    load browse_lists_file
    include HRWA::CollectionBrowseListsSourceHardcoded
  end

end
