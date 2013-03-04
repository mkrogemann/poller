# This class expects a search_term in its constructor which can be
# either a String or a Regexp
#
# The matches? method takes a Net::HTTPResponse object and will apply
# the search_term to the HTTPResponse.body

module Matchers
  module HTTP

    class ResponseBodyContains

      # Expects either a String or a Regexp
      def initialize(search_term)
        @search_term = search_term
      end

      # Expects a Net::HTTPResponse object
      def matches?(http_response)
        return @search_term.match(http_response.body) if @search_term.class == Regexp
        http_response.body.include?(@search_term)
      end

    end

  end
end
