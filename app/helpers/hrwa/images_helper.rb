# -*- encoding : utf-8 -*-
module Hrwa::ImagesHelper

  #Valid size values: 'thumb', 'medium', 'large'
  #Valid recto_or_verso values: 'recto', 'verso'
  #Valid disposition values: 'view', 'download'
  def get_image_uri(document, recto_or_verso, size, disposition='view')
    return images_path(:pid=>document.get(recto_or_verso + '_image_s'), :size=>size, :disposition=>disposition) + '.png'
  end

end
