# This class expects a String holding an XPath expression and a search_term
# in its constructor which can be either a String or a Regexp
#
# The matches? method takes a Net::HTTPResponse object and will apply
# the search_term to the result of the XPath querying the HTTPResponse.body

require 'rexml/document'

module Matchers
  module XML

    class DocumentContainsXPath

      def initialize(xpath_expr_s, occurrences = 1)
        @xpath_expr_s = xpath_expr_s
        @occurrences = occurrences
      end

      def matches?(http_response)
        xml_doc = REXML::Document.new(http_response.body)
        nodes = REXML::XPath.match(xml_doc, @xpath_expr_s)
        nodes.count >= @occurrences
      end

    end

  end
end
