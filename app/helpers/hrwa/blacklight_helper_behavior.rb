# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-

module HRWA::BlacklightHelperBehavior

  # Create form input type=hidden fields representing the entire search context,
  # for inclusion in a form meant to change some aspect of it, like
  # re-sort or change records per page. Can pass in params hash
  # as :params => hash, otherwise defaults to #params. Can pass
  # in certain top-level params keys to _omit_, defaults to :page
  def search_as_hidden_fields(options={})

    options = {:params => params, :omit_keys => [:page]}.merge(options)
    my_params = options[:params].dup
    options[:omit_keys].each do |omit_key|
      case omit_key
        when Hash
          omit_key.each do |key, values|
            next unless my_params[key]
            my_params[key] = my_params[key].dup

            values = [values] unless values.respond_to? :each
            values.each { |v| my_params[key].delete(v) }
          end
        else
          my_params.delete(omit_key)
      end
    end
    # removing action and controller from duplicate params so that we don't get hidden fields for them.
    my_params.delete(:action)
    my_params.delete(:controller)
    # commit is just an artifact of submit button, we don't need it, and
    # don't want it to pile up with another every time we press submit again!
    my_params.delete(:commit)
    # hash_as_hidden_fields in hash_as_hidden_fields.rb

    return hash_as_hidden_fields(my_params)
  end

end
