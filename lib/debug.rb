module Debug
    
  def array_pp( array )
    return array.join( '<br/>' ).html_safe
  end
  
  def array_pp_sorted( array )
    return array.sort_by{ |x| x.to_s }.join( '<br/>' ).html_safe
  end
  
  def hash_pp( hash, no_blanks = true )
    hash_html = ''
    Hash[ hash.sort ].each_pair do |key, value|
      next if value.blank? && no_blanks
      hash_html << "<strong>#{key}</strong> = #{value} <br/>"
    end
    return hash_html.html_safe
  end
  
  def params_list
    return hash_pp( params )
  end
  
end