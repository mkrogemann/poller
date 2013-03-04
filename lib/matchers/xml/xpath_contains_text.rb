require 'rexml/document'

module Matchers
  module XML

    class XPathContainsText

      def initialize(xpath_expr_s, search_term)
        @xpath_expr_s = xpath_expr_s
        @search_term = search_term
      end

      def matches?(http_response)
        xml_doc = REXML::Document.new(http_response.body)
        xpath = REXML::XPath.first(xml_doc, @xpath_expr_s)
        return @search_term.match(xpath.text) if @search_term.class == Regexp
        xpath.text.include?(@search_term)
      end

    end

  end
end