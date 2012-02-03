module Hrwa::Debug
    
  def params_list
    params_list = ''
    Hash[params.sort].each_pair do |key, value|
      next if value.blank?
      params_list << "<strong>#{key}</strong> = #{value} <br/>".html_safe  
    end
    return params_list
  end
  
end