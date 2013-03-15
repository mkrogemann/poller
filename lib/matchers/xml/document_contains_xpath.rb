# This class expects a String holding an XPath expression and an optional
# number of occurrences of the XPath to be found in the document.
#
# The matches? method takes a String (eg response body) and applies the search_term
# to the result of the XPath querying the document given in said String
#
# = Examples
#   dcx = DocumentContainsXPath.new('//ElementA/ElementB')
#
#   dcx = DocumentContainsXPath.new('//ElementA/ElementB', 3)
#

require 'rexml/document'

module Matchers
  module XML

    class DocumentContainsXPath

      # @param xpath_expr_s [String] - the XPath expression
      # @param optional occurences [Integer] - the number of occurences expected in document
      def initialize(xpath_expr_s, occurrences = 1)
        @xpath_expr_s = xpath_expr_s
        @occurrences = occurrences
      end

      # @param document_s [String] - the document given as String
      def matches?(document_s)
        xml_doc = REXML::Document.new(document_s)
        nodes = REXML::XPath.match(xml_doc, @xpath_expr_s)
        nodes.count >= @occurrences
      end

    end

  end
end
