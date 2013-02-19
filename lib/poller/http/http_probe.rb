# The HttpProbe class is built on top of the Ruby built-in net/http library.
# Proxy support is provided. Please note that the Net::HTTP::Proxy  method will
# return a Net::HTTP object if no proxy information is given (ie proxy_hostname is nil)
#
# The 'sample' method will wrap any Exception it may catch into a RuntimeError.
#
# Equally, any HTTP Response other than Net::HTTPSuccess will also get wrapped
# into a RuntimeError as this class expects a GET request to return 200|OK or
# equivalent HTTP Success objects in its current implementation.
#
# HttpProbe also expects a matcher to be passed in. The matcher must return
# either 'true or 'false' when given the http_response for evaluation via
# its 'matches?' method.

require 'uri'
require 'net/http'

module Poller
  module HTTP

    class HttpProbe

      def initialize(url_s, matcher, proxy_hostname = nil, proxy_port = nil, proxy_user = nil, proxy_pwd = nil)
        @uri = URI(url_s)
        @matcher = matcher
        @proxy = Net::HTTP::Proxy(proxy_hostname, proxy_port, proxy_user, proxy_pwd)
      end

      def sample
        begin
          @http_response = @proxy.get_response(@uri)
          return if @http_response.class == Net::HTTPSuccess
        rescue Exception => e
          raise RuntimeError, "#sample caught an Exception of class #{e.class} with message: #{e.message}"
        end
        raise RuntimeError, "HTTP request failed, the error class is: #{@http_response.class}"
      end

      def satisfied?
        return false if @http_response.nil?
        @matcher.matches?(@http_response)
      end

    end

  end
end
