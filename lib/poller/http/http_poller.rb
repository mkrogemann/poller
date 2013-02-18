# The HttpPoller will constuct an HttpProbe and sample it periodically based on
# the value given for period_s until a timeout occurs after timeout_s seconds.
#
# The proxy information is expected to be either nil or given as an OpenStruct
# with attributes 'hostname', 'port', 'user' and 'password'.

require 'poller/poller'

module Poller
  module HTTP

    class HttpPoller
      include Poller

      def initialize(url, timeout_s, period_s, proxy = nil)
        probe = proxy.nil? ? HttpProbe.new(url) : HttpProbe.new(url, proxy.hostname, proxy.port, proxy.user, proxy.password)
        super(probe, timeout_s, period_s)
      end

    end

  end
end
