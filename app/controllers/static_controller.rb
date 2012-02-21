# -*- encoding : utf-8 -*-

# This controller handles all requests static HTML pages
class StaticController < ApplicationController  

  def about
    @content = "Hello About Page!"
  end
  
  def collection_browse
    @content = "Hello Collection Browse Page!"
  end

  def contact
    @content = "Hello Contact Page!"
  end
  
  def faq
    @content = "Hello FAQ Page!"
  end

  def index
    @content = "Hello Home Page!"
  end
  
  def search_home
    @content = "Hello Search Home!"
  end

end 
