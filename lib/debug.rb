module Debug
    
  def params_list
    return hash_pp( params )
  end
  
  def hash_pp( hash, no_blanks = true )
    hash_html = ''
    Hash[ hash.sort ].each_pair do |key, value|
      next if value.blank? && no_blanks
      hash_html << "<strong>#{key}</strong> = #{value} <br/>"
    end
    return hash_html.html_safe
  end
  
end