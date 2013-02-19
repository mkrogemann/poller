# This class expects a Net::HTTPResponse object and a second argument in its constructor.
# The second argument can be a String or a Regexp

module Matchers
  module HTTP

    class ResponseBodyContains

      def initialize(search_term)
        @search_term = search_term
      end

      def matches?(http_response)
        return @search_term.match(http_response.body) if @search_term.class == Regexp
        http_response.body.include?(@search_term)
      end

    end

  end
end
