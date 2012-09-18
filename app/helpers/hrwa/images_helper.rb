# -*- encoding : utf-8 -*-
module Hrwa::ImagesHelper

  #Valid size values: 140, 640
  def get_image_uri(document, size)
    if(request.host == 'localhost')
      return 'http://hrwa-test.cul.columbia.edu/hrwa_images/website_screenshots/' + size.to_s + 'px/' + document.get('id') + '.jpeg'
    else
      return '/hrwa_images/website_screenshots/' + size.to_s + 'px/' + document.get('id') + '.jpeg'
    end
  end

end
