module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # Contains local overrides of Blacklight::CatalogHelperBehavior methods
  include HRWA::CatalogHelperBehavior

  # Override
  def has_search_parameters?
    if params[ :search_mode ] == 'advanced'
      return( ! params[ :q_and        ].blank? or
              ! params[ :q_exclude    ].blank? or
              ! params[ :q_phrase     ].blank? or
              ! params[ :q_not        ].blank? or
              ! params[ :f            ].blank? or
              super )
    else
      super
    end
  end
end
