module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # Contains local overrides of Blacklight::CatalogHelperBehavior methods
  include HRWA::CatalogHelperBehavior

  include HRWA::CollectionBrowseLists
  include HRWA::FilterOptions

end
