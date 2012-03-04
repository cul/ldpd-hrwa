module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # Contains local overrides of Blacklight::CatalogHelperBehavior methods
  include HRWA::CatalogHelperBehavior

  include HRWA::FilterOptions
  include HRWA::BrowseOptions
end
