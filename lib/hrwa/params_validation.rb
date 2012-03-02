module HRWA::ParamsValidation

  def recursively_remove_blank_items!(hash_or_array)
    if(hash_or_array.is_a?(Hash))
      hash_or_array.delete_if { | key, value | value.blank? or ((value.instance_of?(Hash) || value.instance_of?(Array) ) && recursively_remove_blank_items!(value).empty?) }
    else
      hash_or_array.delete_if { | value | value.blank? or ((value.instance_of?(Hash) || value.instance_of?(Array) ) && recursively_remove_blank_items!(value).empty?) }
    end
  end

  def recursively_remove_blank_items(hash_or_array = params, top_level = true)

    if(top_level)
      #We'll make a deep copy of the hash and return a modified version of that copy
      hash_or_array = Marshal.load(Marshal.dump(hash_or_array))
      top_level = false
    end

    if(hash_or_array.is_a?(Hash))
      hash_or_array.delete_if { | key, value | value.blank? or ((value.instance_of?(Hash) || value.instance_of?(Array) ) && recursively_remove_blank_items(value, top_level).empty?) }
    else
      hash_or_array.delete_if { | value | value.blank? or ((value.instance_of?(Hash) || value.instance_of?(Array) ) && recursively_remove_blank_items(value, top_level).empty?) }
    end

    return hash_or_array

  end

end

############################ Spec Code: Re-add later if the above methods are used

=begin
describe 'recursively_remove_blank_items and recursively_remove_blank_items!' do

  sample_params =
  {
    :action => 'index',
    :commit => 'search ',
    :controller => 'catalog',
    :hrwa_debug => true,
    :q => '+water',
    :search_mode => 'advanced',
    :search_type => 'find_site',
    :sort => 'score desc',

    :f => {"organization_type__facet"=>[""], "subject__facet"=>["Human rights"], "geographic_focus__facet"=>["[Global focus]"], "organization_based_in__facet"=>["United States"], "language__facet"=>["English"], "title"=>["right"], "creator_name__facet"=>["Center for Economic and Social Rights"], "original_urls"=>["http://www.cesr.org/"]},
    :q_and => '',
    :test1 => [],
    :test2 => [{}],
    :test3 => [{'item1' => 'value1', 'item2' => '', 'item3' => nil, 'item4' => 2}],
    :test4 => {1 => {'item1' => 'value1', 'item2' => '', 'item3' => nil}, 2 => ''},
    :test5 => {'item1' => '', 'item2' => ['item1', 'item2', {'' => ''}]},
    :test6 => {'item' => '', { 'zzz' => 'aaa' } => '',  'item2' => [{'' => [[]]}] },
  }

  expected_params =
  {
    :action => 'index',
    :commit => 'search ',
    :controller => 'catalog',
    :hrwa_debug => true,
    :q => '+water',
    :search_mode => 'advanced',
    :search_type => 'find_site',
    :sort => 'score desc',

    :f => {"subject__facet"=>["Human rights"], "geographic_focus__facet"=>["[Global focus]"], "organization_based_in__facet"=>["United States"], "language__facet"=>["English"], "title"=>["right"], "creator_name__facet"=>["Center for Economic and Social Rights"], "original_urls"=>["http://www.cesr.org/"]},
    :test3 => [{'item1' => 'value1', 'item4' => 2}],
    :test4 => {1 => {'item1' => 'value1'}},
    :test5 => {'item2' => ['item1', 'item2']},
  }

  it 'will recursively remove items that are blank and leave items that aren\'t blank' do

    recursively_remove_blank_items(sample_params).should == expected_params

    recursively_remove_blank_items!(sample_params).should == expected_params
  end

end
=end
