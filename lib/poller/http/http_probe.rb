# The HttpProbe class is built on top of the Ruby built-in net/http library.
# Proxy support is provided. Please note that the Net::HTTP::Proxy will return
# a Net::HTTP object if no proxy information is given (ie proxy_hostname is nil)

require 'uri'
require 'net/http'

module Poller
  module HTTP

    class HttpProbe

      def initialize(url_s, proxy_hostname = nil, proxy_port = nil, proxy_user = nil, proxy_pwd = nil)
        @uri = URI(url_s)
        @proxy = Net::HTTP::Proxy(proxy_hostname, proxy_port, proxy_user, proxy_pwd)
      end

      def sample
        begin
          http_response = @proxy.get_response(@uri)
          return http_response if http_response.class == Net::HTTPSuccess
        rescue Exception => e
          raise RuntimeError, "#sample caught an Excpetion of class #{e.class} with message: #{e.message}"
        end
        raise RuntimeError, "HTTP request failed, the error class is: #{http_response.class}"
      end

    end

  end
end
