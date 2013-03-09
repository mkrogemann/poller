# This class expects a String holding an XPath expression and a search_term
# in its constructor which can be either a String or a Regexp
#
# The matches? method takes a Net::HTTPResponse object and will apply
# the search_term to the result of the XPath querying the HTTPResponse.body

require 'rexml/document'

module Matchers
  module XML

    class XPathContainsText

      # @param xpath_expr_s [String] - the XPath expression
      # @param search_term [String | Regexp] - the search term
      def initialize(xpath_expr_s, search_term)
        @xpath_expr_s = xpath_expr_s
        @search_term = search_term
      end

      # @param http_response [Net::HTTPResponse object] - the http response
      def matches?(http_response)
        xml_doc = REXML::Document.new(http_response.body)
        xpath = REXML::XPath.first(xml_doc, @xpath_expr_s)
        return @search_term.match(xpath.text) if @search_term.class == Regexp
        xpath.text.include?(@search_term)
      end

    end

  end
end