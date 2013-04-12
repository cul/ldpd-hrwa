require 'spec_helper'

class MockSearchExpander
  include Hrwa::SearchExpansion::SearchExpander
end

describe 'Hrwa::SearchExpansion::SearchExpander' do

  before ( :all ) do
    @search_expander = MockSearchExpander.new
    @search_expander.cache_search_expansion_csv_file_data
  end

  describe '#find_expanded_search_terms_for_query' do
    it 'finds search expansion terms for a known expandable query' do
      at_least_one_expanded_search_term_found, query_terms_with_expanded_search_terms_arr = @search_expander.find_expanded_search_terms_for_query('aleuts velociraptor')
      at_least_one_expanded_search_term_found.should == true
      puts query_terms_with_expanded_search_terms_arr.should == [{"aleuts"=>["Unangan", "Unangas"]}, {"velociraptor"=>nil}]
    end

    it 'does not find search expansion terms for a known non-expandable query' do
      at_least_one_expanded_search_term_found, query_terms_with_expanded_search_terms_arr = @search_expander.find_expanded_search_terms_for_query('velociraptor tyrannosaurus')
      at_least_one_expanded_search_term_found.should == false
      puts query_terms_with_expanded_search_terms_arr.should == [{"velociraptor"=>nil}, {"tyrannosaurus"=>nil}]
    end

    it 'finds search expansion terms for a quoted, multi-word known expandable query' do
      at_least_one_expanded_search_term_found, query_terms_with_expanded_search_terms_arr = @search_expander.find_expanded_search_terms_for_query('"depressed classes"')
      at_least_one_expanded_search_term_found.should == true
      puts query_terms_with_expanded_search_terms_arr.should == [{"\"depressed classes\""=>["Dalits", "Harijans", "Scheduled castes", "Untouchables"]}]
    end

    it 'finds search expansion terms for multi-word known expandable query even when that multi-word query is not quoted (two word term)' do
      at_least_one_expanded_search_term_found, query_terms_with_expanded_search_terms_arr = @search_expander.find_expanded_search_terms_for_query('information depressed classes government')
      at_least_one_expanded_search_term_found.should == true
      puts query_terms_with_expanded_search_terms_arr.should == [{"information"=>nil}, {"\"depressed classes\""=>["Dalits", "Harijans", "Scheduled castes", "Untouchables"]}, {"government"=>nil}]
    end

    it 'finds search expansion terms for multi-word known expandable query even when that multi-word query is not quoted (three word term)', :focus => true do
      at_least_one_expanded_search_term_found, query_terms_with_expanded_search_terms_arr = @search_expander.find_expanded_search_terms_for_query('information Lac Courte Oreilles government')
      at_least_one_expanded_search_term_found.should == true
      puts query_terms_with_expanded_search_terms_arr.should == [{"information"=>nil}, {"\"Lac Courte Oreilles\""=>["Algic", "Anishinabe", "Bawichtigoutek", "Bungee", "Bungi", "Chipouais", "Chippewa", "Ochepwa", "Odjibway", "Ojebwa", "Ojibua", "Ojibwa", "Ojibwauk", "Ojibway", "Ojibwe", "Otchilpwe", "Salteaux", "Saulteaux"]}, {"government"=>nil}]
    end
  end

  describe '#split_search_query_on_double_quotation_marks_and_spaces_and_parentheses_but_preserve_double_quotes' do
    it 'preserves double quotation marks' do
      array_of_query_pieces = @search_expander.split_search_query_on_double_quotation_marks_and_spaces_and_parentheses_but_preserve_double_quotes('this is a test "with quotes" in it "and" here "are some more" quotes')
      array_of_query_pieces.should == ["this", "is", "a", "test", "\"with quotes\"", "in", "it", "and", "here", "\"are some more\"", "quotes"]
    end

    it 'knows to separate parentheses from immediately-adjacent non-parentheses characters' do
      array_of_query_pieces = @search_expander.split_search_query_on_double_quotation_marks_and_spaces_and_parentheses_but_preserve_double_quotes('(aleuts)')
      array_of_query_pieces.should == ["(", "aleuts", ")"]
    end
  end

  describe '#find_expanded_terms_for_single_word' do

    it 'returns synonyms for a known expandable word' do
      expanded_terms = @search_expander.find_expanded_terms_for_single_word('aleuts')
      expanded_terms.should == ["Unangan", "Unangas"]
    end

    it 'returns nil for a known non-expandable word' do
      expanded_terms = @search_expander.find_expanded_terms_for_single_word('velociraptor')
      expanded_terms.should == nil
    end

    it 'returns nil for some stopwords' do
      expanded_terms = @search_expander.find_expanded_terms_for_single_word('OR')
      expanded_terms.should == nil
      expanded_terms = @search_expander.find_expanded_terms_for_single_word('AND')
      expanded_terms.should == nil
      expanded_terms = @search_expander.find_expanded_terms_for_single_word('(')
      expanded_terms.should == nil
      expanded_terms = @search_expander.find_expanded_terms_for_single_word(')')
      expanded_terms.should == nil
    end
  end

  describe '#get_expanded_query_from_expanded_search_terms_array' do
    it 'returns the expected expanded query - test 1 (single word)' do
      expanded_search_terms_found, expanded_search_terms = @search_expander.find_expanded_search_terms_for_query('aleuts')
      expanded_query = @search_expander.get_expanded_query_from_expanded_search_terms_array(expanded_search_terms)
      expanded_query.should == "(aleuts OR Unangan OR Unangas)"
    end

    it 'returns the expected expanded query - test 2 (words with quotation marks and a known expandable word wrapped in double quotation marks)' do
      expanded_search_terms_found, expanded_search_terms = @search_expander.find_expanded_search_terms_for_query('this is a "great test" with the word "aleuts"')
      expanded_query = @search_expander.get_expanded_query_from_expanded_search_terms_array(expanded_search_terms)
      expanded_query.should == "this AND is AND a AND \"great test\" AND with AND the AND word AND (aleuts OR Unangan OR Unangas)"
    end

    it 'returns the expected expanded query - test 3 (intentionally ignoring an expandable word because it and another word are grouped together within quotation marks)' do
      expanded_search_terms_found, expanded_search_terms = @search_expander.find_expanded_search_terms_for_query('the word "aleuts zzz"')
      expanded_query = @search_expander.get_expanded_query_from_expanded_search_terms_array(expanded_search_terms)
      expanded_query.should == "the AND word AND \"aleuts zzz\""
    end

    it 'returns the expected expanded query - test 4 (properly expanding an expandable quoted multi-word term)' do
      expanded_search_terms_found, expanded_search_terms = @search_expander.find_expanded_search_terms_for_query('Chippewa')
      expanded_query = @search_expander.get_expanded_query_from_expanded_search_terms_array(expanded_search_terms)
      expanded_query.should == "(Chippewa OR Algic OR Anishinabe OR Bawichtigoutek OR Bungee OR Bungi OR Chipouais OR \"Lac Courte Oreilles\" OR Ochepwa OR Odjibway OR Ojebwa OR Ojibua OR Ojibwa OR Ojibwauk OR Ojibway OR Ojibwe OR Otchilpwe OR Salteaux OR Saulteaux)"
    end

    it 'returns the expected expanded query - test 5 (identifying a NON-quoted multi-word expandable term - TEST with exact match to lower case multi-word term "depressed classes")' do
      expanded_search_terms_found, expanded_search_terms = @search_expander.find_expanded_search_terms_for_query('information depressed classes government')
      expanded_query = @search_expander.get_expanded_query_from_expanded_search_terms_array(expanded_search_terms)
      expanded_query.should == "information AND (\"depressed classes\" OR Dalits OR Harijans OR \"Scheduled castes\" OR Untouchables) AND government"
    end

    it 'returns the expected expanded query - test 6 (identifying a NON-quoted multi-word expandable term - TEST with case-insensitive match to "LaC CoUrTe OrEiLlEs")', :focus => true do
      expanded_search_terms_found, expanded_search_terms = @search_expander.find_expanded_search_terms_for_query('information LaC CoUrTe OrEiLlEs government')
      expanded_query = @search_expander.get_expanded_query_from_expanded_search_terms_array(expanded_search_terms)
      expanded_query.should == "information AND (\"LaC CoUrTe OrEiLlEs\" OR Algic OR Anishinabe OR Bawichtigoutek OR Bungee OR Bungi OR Chipouais OR Chippewa OR Ochepwa OR Odjibway OR Ojebwa OR Ojibua OR Ojibwa OR Ojibwauk OR Ojibway OR Ojibwe OR Otchilpwe OR Salteaux OR Saulteaux) AND government"
    end
  end

end
