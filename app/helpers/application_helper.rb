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

    image_tag("https://web.archive.org/thumb/#{site}?generate=1", options.merge(alt: document['meta_Title']))
  end

end
