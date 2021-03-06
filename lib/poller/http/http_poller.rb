# The HttpPoller will constuct an HttpProbe and sample it periodically based on
# the value given for period_seconds until a timeout occurs after timeout_seconds.
#
# The proxy information is expected to be either nil or given as an OpenStruct
# with attributes 'hostname', 'port', 'user' and 'password'.
# It is also possible to pass in the information as a Hash that will get converted
# internally into an OpenStruct. In this case, make sure you use these keys:
# { :hostname => 'proxy.internal.com', :port => 8080, :user => 'user', :password => 'pwd' }

require 'poller/poller'
require 'poller/http/http_probe'
require 'ostruct'

module Poller
  module HTTP

    class HttpPoller
      include Poller

      def initialize(url, matcher, timeout_seconds, period_seconds, proxy = nil)
        proxy = OpenStruct.new(proxy) if proxy.is_a?(Hash)
        probe = proxy.nil? \
          ? HttpProbe.new(url, matcher) \
          : HttpProbe.new(url, matcher, proxy.hostname, proxy.port, proxy.user, proxy.password)
        super(probe, timeout_seconds, period_seconds, url)
      end

    end

  end
end
