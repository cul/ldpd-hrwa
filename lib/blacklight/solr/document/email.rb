# -*- encoding : utf-8 -*-

# ! Override !
# This module provides the body of an email export based on the document's semantic values
module Blacklight::Solr::Document::Email

  # Return a text string that will be the body of the email
  def to_email_text
    semantics = self.to_semantic_values
    body = ""
    body << "Title: #{semantics[:title].join(" ")}" unless semantics[:title].blank?
    return body unless body.blank?
  end

end
