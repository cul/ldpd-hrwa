# -*- encoding : utf-8 -*-
module Hrwa::MimetypeHelper

  def mimetype_code_to_display_string(mimetype_code)

    codes_to_strings = get_mimetype_codes

    return codes_to_strings[mimetype_code]

  end

  def get_mimetype_codes
    return {
      'DOCUMENT' => 'Document',
      'HTML' => 'HTML',
      'PDF' => 'PDF',
      'SLIDESHOW' => 'Presentation',
      'SPREADSHEET' => 'Spreadsheet',
      'XML' => 'XML',
    }
  end

end
