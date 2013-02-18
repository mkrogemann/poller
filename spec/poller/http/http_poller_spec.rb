require 'spec_helper'
require 'poller/http/http_poller'
require 'ostruct'

module Poller
  module HTTP

    describe HttpPoller do

      context '#initialize' do

        it 'constructs an HttpPoller with an HttpProbe constructed from a URL' do
          http_poller = HttpPoller.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil, Float::MAX, Float::MIN)

          probe = http_poller.instance_variable_get(:@probe)

          probe.class.should == HttpProbe
        end

        it 'constructs an HttpPoller with Proxy information given in an OpenStruct' do
          proxy = OpenStruct.new
          proxy.hostname = 'proxy.internal.com'
          proxy.port = 8080
          proxy.user = 'proxy_user'
          proxy.password = 'humptydumpty'
          http_poller = HttpPoller.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil, Float::MAX, Float::MIN, proxy)

          probe = http_poller.instance_variable_get(:@probe)
          probe_proxy = probe.instance_variable_get(:@proxy)

          probe_proxy.proxy_user.should == 'proxy_user'
        end

      end

    end

  end
end

