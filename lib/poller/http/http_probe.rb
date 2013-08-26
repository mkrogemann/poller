# The HttpProbe class is built on top of the Ruby built-in net/http library.
# Proxy support is provided. Please note that the Net::HTTP::Proxy method will
# return a Net::HTTP object if no proxy information is given (ie if proxy_hostname
# is nil).
#
# The 'sample' method will wrap any Exception it may catch into a RuntimeError.
#
# Equally, any HTTP Response other than Net::HTTPOK will also get wrapped
# into a RuntimeError as this class expects a GET request to return 200|OK or
# in its current implementation. Redirects will therefore be regarded as a failure.
#
# HttpProbe also expects a matcher to be passed in. The matcher must return
# either 'true or 'false' when given the http_response for evaluation via
# its 'matches?' method.
#
# SSL is supported but certificates are not verified.
#
# Basic Auth is also supported in case userinfo appears in the passed in URL.

require 'uri'
require 'net/http'
require 'net/https'

module Poller
  module HTTP

    class HttpProbe

      def initialize(url_s, matcher, proxy_hostname = nil, proxy_port = nil, proxy_user = nil, proxy_pwd = nil)
        @uri = URI.parse(url_s)
        @matcher = matcher
        @proxy = Net::HTTP::Proxy(proxy_hostname, proxy_port, proxy_user, proxy_pwd).new(@uri.host, @uri.port)
      end

      def sample
        begin
          # support SSL, not veryfing the SSL certificates (out of scope from my perspective)
          if @uri.scheme == 'https'
            @proxy.use_ssl = true
            @proxy.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          request = Net::HTTP::Get.new(@uri.request_uri)
          # support basic auth if userinfo appears in url
          if @uri.userinfo
            request.basic_auth(@uri.user, @uri.password)
          end
          @http_response = @proxy.request(request)
          return @http_response if @http_response.class == Net::HTTPOK
        rescue Exception => e
          raise RuntimeError, "#sample caught an Exception of class #{e.class} with message: #{e.message}"
        end
        raise RuntimeError, "HTTP request failed, the error class is: #{@http_response.class}"
      end

      def satisfied?
        return false if @http_response.nil?
        @matcher.matches?(@http_response.body)
      end

    end

  end
end
