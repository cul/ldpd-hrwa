# encoding: UTF-8

require 'shellwords'

module Hrwa::SearchExpansion::SearchExpander

  ## Creating class variable for class-caching purposes
  @@search_expansion_hash_CACHED = nil

  # Given a query q, this method checks for expanded (related) search terms
  # and returns a hash mapping each query term to its related search terms.
  # If no related search terms are found, this method returns nil
  def find_expanded_search_terms_for_query(q)

    start_time = Time.now

    at_least_one_expanded_search_term_found = false
    # This (below) needs to be an array (rather than a hash) so that if a user
    # re-uses a word in their query, the second instance of that word isn't lost
    # (because adding the same string key twice to a hash would only result in a
    # single hash element).
    query_terms_with_expanded_search_terms_arr = []

    search_terms = split_search_query_on_double_quotation_marks_and_spaces_and_parentheses_but_preserve_double_quotes(q).each {|term| term.strip!}

    search_terms.each { | term |
      #if term starts and ends with double quottation marks, then attempt to do a synonym lookup of the text contained within those quotation marks
      if(term =~ /^".+"$/)
        #quoted term found
        expanded_terms_for_single_term = find_expanded_terms_for_single_word(term.slice(1..term.length-2))
      else
        #normal single-word term found
        expanded_terms_for_single_term = find_expanded_terms_for_single_word(term)
      end

      query_terms_with_expanded_search_terms_arr.push({term => expanded_terms_for_single_term})
      if ! expanded_terms_for_single_term.nil?
        at_least_one_expanded_search_term_found = true
      end
    }

    Rails.logger.debug(
      "Search expansion occurred. Expansion time: " + ((Time.now - start_time)*1000).to_i.to_s + " milliseconds"
    )

    return at_least_one_expanded_search_term_found, query_terms_with_expanded_search_terms_arr
  end

  #Example usage:
  # String: 'this is a test "with quotes" in it "and" here "are some more" quotes'
  # Output: ['this', 'is', 'a', 'test', '"with quotes"', 'in', 'it', 'and', 'here', '"are some more"', 'quotes']
  # Another example with parentheses
  # String: '(aleuts)'
  # Output: [' ( ', 'aleuts', ' ) ']
  def split_search_query_on_double_quotation_marks_and_spaces_and_parentheses_but_preserve_double_quotes(q)

    # Add spaces around parentheses so that they're not grouped with terms during synonym detection
    # These ' ( ' and ' ) ' query snippets will be converted back to normal parentheses when the expanded query string is created
    q = q.gsub('(', ' ( ').gsub(')', ' ) ')

    #Temporarily replace apostrophes so that they don't count as quotes
    pieces = Shellwords.split(q.gsub("'", '|||||')).each { |item| item.gsub!('|||||', "'")}

    #If any piece contains a space, that means that it was quotes and it should be wrapped in dobule quotation marks

    pieces.each_index { |element_index| pieces[element_index] = '"' + pieces[element_index] + '"' unless pieces[element_index].index(' ').nil? }

    return pieces

  end

  def find_expanded_terms_for_single_word(single_word)

    single_word_downcase = single_word.downcase #make comparison case insensitive

    # If single_word is on the ignore_words list, return nil
    ignore_words = ['OR', 'AND', '(', ')', 'the', 'and', 'in', 'on', 'at', 'into']
    if ignore_words.include?(single_word_downcase)
      return nil
    end

    if @@search_expansion_hash_CACHED.nil?
      # We want to cache the search_expansion_terms.csv file data into memory as a hash (using Rails class caching)
      Rails.logger.debug("Cache is NOT available for @@search_expansion_hash_CACHED.  Loading from file.")
      @@search_expansion_hash_CACHED = get_search_expansion_hash_from_csv_file('lib/hrwa/search_expansion/search_expansion_terms.csv')
    end

    # Now we'll check to see if single_word exists within the set of search expansion terms
    if(expanded_terms = @@search_expansion_hash_CACHED[single_word_downcase.to_sym])
      expanded_terms = expanded_terms.dup # Important! Make a DUPLICATE of the returned expanded_terms array so that we don't modify the original in @@search_expansion_hash_CACHED
      #case-insensitive deletion of the same-name item in the array
      expanded_terms.delete_if { |item|
        item.downcase == single_word.downcase
      }
      return expanded_terms
    end

    return nil

  end

  # Returns a hash that maps each expansion term to its group of related expansion terms
  # Note: Groups of related expansion terms contain ALL related expansion terms, including
  # whichever hash key is mapping to that group. Keys and values are all lower case
  # Sample structure: { :adi => ['adi','abo','abor','abors','tangam'], :adivasis => ['adivasis','adibasis'], :adibasis => ['adivasis','adibasis'] }
  def get_search_expansion_hash_from_csv_file(path_to_csv_file)

    search_expansion_hash_to_return = {}

    file_content = File.read(path_to_csv_file)
    file_content.gsub!(/,{2,}/, '') # Remove adjacent commas whenever two or more are next to each other (because these appear at the end of some rows when the number of columns varies)

    # By default, File.open automatically removes carriage returns (\r), so we don't need to worry about them
    # See: http://stackoverflow.com/questions/287713/how-do-i-remove-carriage-returns-with-ruby

    #Split lines on new line character (\n)
    lines = file_content.split("\n")

    lines.each { |line|

      # Convert each line into an array of words without leading or trailing whitespace
      array_for_this_line = []
      line.split(',').each { |word|
        array_for_this_line.push(word.strip)
      }

      # For each word in the newly-generated array, put that word in
      # search_expansion_hash_to_return and have it point its own associated
      # array of related terms.
      # NOTE: The associated array of related terms DOES contain the original
      # word that is being matched, but this is because I don't want to create
      # tons and tons of arrays for the many different combinations of
      # associated synonyms (otherwise we'll have one unique array per word
      # in the search expansion terms file).  Basically, I'm trying to use
      # less memory.
      array_for_this_line.each { |expansion_synonym|
        search_expansion_hash_to_return[expansion_synonym.downcase.to_sym] = array_for_this_line.sort! # Sort terms in alphabetical order
      }

    }

    if search_expansion_hash_to_return.empty?
      raise "Error: The list of search expansion terms is unavailable."
    end

    return search_expansion_hash_to_return

  end

  def get_expanded_query_from_expanded_search_terms_array(expanded_search_terms_arr)
    
    expanded_query_to_return = ''

    expanded_search_terms_arr.each_index { |index|
      expanded_search_terms_arr[index].each { |term, array_of_related_terms|
        if array_of_related_terms.nil?
          if index == 0
            #start of search terms
            expanded_query_to_return += "#{term} AND "
          elsif index == (expanded_search_terms_arr.length - 1)
            #end of search terms
            expanded_query_to_return += "AND #{term}"
          else
            #middle of search terms
            expanded_query_to_return += "AND #{term} AND "
          end
        else


          related_terms_delimited_by_OR = ''
          array_of_related_terms.each { |term|
            if term.index(' ').nil?
              related_terms_delimited_by_OR += term + ' OR '
            else
              related_terms_delimited_by_OR += '"' + term + '" OR ' # Need to use quotation marks around multi-word synonyms
            end

          }
          #remove trailing ' OR '
          related_terms_delimited_by_OR = related_terms_delimited_by_OR.slice(0..related_terms_delimited_by_OR.length-5)

          if index == 0
            #start of search terms
            expanded_query_to_return += "(#{term} OR #{related_terms_delimited_by_OR}) AND "
          elsif index == (expanded_search_terms_arr.length - 1)
            #end of search terms
            expanded_query_to_return += "AND (#{term} OR #{related_terms_delimited_by_OR})"
          else
            #middle of search terms
            expanded_query_to_return += "AND (#{term} OR #{related_terms_delimited_by_OR}) AND "
          end
        end
      }
    }
    expanded_query_to_return.strip!

    # Remove "AND AND" (that might have been introduced by query expansion) with "AND"
    expanded_query_to_return.gsub!(/AND AND/, 'AND')

    # Remove trailing ' AND' (that might have been introduced by query expansion)
    expanded_query_to_return = expanded_query_to_return.slice(0, expanded_query_to_return.length-4) if expanded_query_to_return.ends_with?(' AND')

    # Replace "AND OR AND" (that might have been introduced by query expansion) with "OR"
    expanded_query_to_return.gsub!(/AND OR AND/, 'OR')

    # Replace "AND AND AND" (that might have been introduced by query expansion) with "AND"
    expanded_query_to_return.gsub!(/AND AND AND/, 'AND')

    # Replace "( AND (" (that might have been introduced by query expansion) with "(("
    expanded_query_to_return.gsub!(/\( AND \(/, '((')

    # Replace ") AND )" (that might have been introduced by query expansion) with "))"
    expanded_query_to_return.gsub!(/\) AND \)/, '))')

    return expanded_query_to_return

  end

end
