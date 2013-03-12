# This class expects a String holding an XPath expression and an optional
# number of occurrences of the XPath to be found in the document.
#
# The matches? method takes a Net::HTTPResponse object and will apply
# the search_term to the result of the XPath querying the HTTPResponse.body
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

      # @param http_response [Net::HTTPResponse object] - the http response
      def matches?(http_response)
        xml_doc = REXML::Document.new(http_response.body)
        nodes = REXML::XPath.match(xml_doc, @xpath_expr_s)
        nodes.count >= @occurrences
      end

    end

  end
end
