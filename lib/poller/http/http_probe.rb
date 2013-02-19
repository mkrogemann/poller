# The HttpProbe class is built on top of the Ruby built-in net/http library.
# Proxy support is provided. Please note that the Net::HTTP::Proxy will return
# a Net::HTTP object if no proxy information is given (ie proxy_hostname is nil)
#
# The 'sample' method will wrap any Exception it may catch into a RuntimeError.
#
# Equally, any HTTP Response other than Net::HTTPSuccess will also get wrapped
# into a RuntimeError as this class expects a GET request to return 200|OK in
# its current implementation.
#
# HttpProbe also expects a matcher_class to be passed in. This must be a class
# name of a class that can be constructed into objects that return either 'true'
# or 'false' when sent the 'satisfied?' message

require 'uri'
require 'net/http'

module Poller
  module HTTP

    class HttpProbe

      def initialize(url_s, matcher_class, proxy_hostname = nil, proxy_port = nil, proxy_user = nil, proxy_pwd = nil)
        @uri = URI(url_s)
        @matcher_class = matcher_class
        @proxy = Net::HTTP::Proxy(proxy_hostname, proxy_port, proxy_user, proxy_pwd)
      end

      def sample
        begin
          http_response = @proxy.get_response(@uri)
          return http_response if http_response.class == Net::HTTPSuccess
        rescue Exception => e
          raise RuntimeError, "#sample caught an Exception of class #{e.class} with message: #{e.message}"
        end
        raise RuntimeError, "HTTP request failed, the error class is: #{http_response.class}"
      end

    end

  end
end
