require 'net/http'

module ApplicationHelper

  def get_ia_generated_thumbnail(document, options={})
    return unless document['canonicalUrl']

    full_url = document['canonicalUrl']
    return unless full_url =~ URI::regexp

    site = nil
    begin
      site = URI.parse(full_url).host
    rescue URI::InvalidURIError => e
      return
    end
    thumbnail_url_base = Rails.application.config_for(:blacklight)['thumbnail_generator_url']
    image_tag("#{thumbnail_url_base}/#{site}", options.merge(alt: document['meta_Title'], onerror: "this.style.display='none'"))
  end

end
