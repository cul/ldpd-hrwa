# -*- encoding : utf-8 -*-
module Hrwa::CatalogHelperBehavior
  # Override
  def has_search_parameters?
    if params[:search_mode] == 'advanced' 
      return( !params[:q_and].blank?     or 
              !params[:q_exclude].blank? or
              !params[:q_phrase].blank?  or
              !params[:q_not].blank?     or
              !params[:f].blank?         or 
              !params[:search_field].blank? )
    else
      super
    end
  end  
end
