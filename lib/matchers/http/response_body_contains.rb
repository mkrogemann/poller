# This class expects a search_term in its constructor which can be
# either a String or a Regexp
#
# The matches? method takes a String (http response body) and applies
# the search_term to it

module Matchers
  module HTTP

    class ResponseBodyContains

      # @param search_term [String | Regexp] - the search term
      def initialize(search_term)
        @search_term = search_term
      end

      # @param body_s [String] - the http response body
      def matches?(body_s)
        return @search_term.match(body_s) if @search_term.class == Regexp
        body_s.include?(@search_term)
      end

    end

  end
end
