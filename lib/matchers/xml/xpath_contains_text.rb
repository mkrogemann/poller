# This class expects a String holding an XPath expression and a search_term
# in its constructor which can be either a String or a Regexp
#
# The matches? method takes a String (eg response body) and applies the search_term
# to the result of the XPath querying the document given in said String
#
# = Example
#   xct = XPathContainsText.new('//ElementA/ElementB', 'Text that I expect')
#

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

      # @param document_s [String] - the XML document given as String
      def matches?(document_s)
        xml_doc = REXML::Document.new(document_s)
        xpath = REXML::XPath.first(xml_doc, @xpath_expr_s)
        return false if xpath.nil?
        return @search_term.match(xpath.text) if @search_term.class == Regexp
        xpath.text.include?(@search_term)
      end

    end

  end
end