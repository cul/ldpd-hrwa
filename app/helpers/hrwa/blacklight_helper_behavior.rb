# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-

module HRWA::BlacklightHelperBehavior

  # Create form input type=hidden fields representing all params[:f] items
  def current_f_hash_as_hidden_fields()

    options = {:params => params}
    my_params = {:f => nil}
    my_params[:f] = options[:params][:f] ? options[:params][:f].dup : {}

    return hash_as_hidden_fields(my_params)
  end

end
