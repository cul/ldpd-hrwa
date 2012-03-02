# -*- encoding : utf-8 -*-
module HRWA::Catalog
  extend ActiveSupport::Concern

  include Blacklight::Catalog

  include HRWA::SolrHelper

end
