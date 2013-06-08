require 'spec_helper'
require 'poller/http/http_probe'

module Poller
  module HTTP

    describe HttpProbe do
      describe '#initialize' do

        it 'accepts a URL given as a String and converts it to a URI' do
          http_probe = HttpProbe.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil)

          uri = http_probe.instance_variable_get(:@uri)

          uri.request_uri.should == '/resource?id=1&token=asldfhljdhru74'
          uri.scheme.should == 'http'
          uri.host.should == 'example.com'
        end

        it 'accepts a URL, a proxy hostname and a proxy port' do
          http_probe = HttpProbe.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil, 'proxy.internal.com', 8080)

          http_proxy = http_probe.instance_variable_get(:@proxy)

          http_proxy.proxy_port.should == 8080
        end

        it 'accepts a URL, a proxy hostname, a proxy port and a proxy user/password pair' do
          http_probe = HttpProbe.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil, 'proxy.internal.com', 8080, 'user', 'pwd')

          http_proxy = http_probe.instance_variable_get(:@proxy)

          http_proxy.proxy_user.should == 'user'
          http_proxy.proxy_pass.should == 'pwd'
        end

      end


      describe '#sample' do

        let(:http_proxy) { double('http_proxy') }
        let(:http_response) { double('http_response') }
        let(:http_request) { double('http_request') }

        it 'triggers an http request to the specified URL and exposes the response in case the request was successful' do
          http_probe = HttpProbe.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil)
          http_probe.instance_variable_set(:@proxy, http_proxy)

          http_proxy.should_receive(:request).and_return(http_response)
          http_response.should_receive(:class).twice.and_return(Net::HTTPOK)

          http_probe.sample
          response = http_probe.instance_variable_get(:@http_response)

          response.class.should == Net::HTTPOK
        end

        it 'triggers an http request to the specified URL and raises a RuntimeError in case the request was not successful' do
          http_probe = HttpProbe.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil)
          http_probe.instance_variable_set(:@proxy, http_proxy)

          http_proxy.should_receive(:request).and_return(http_response)
          http_response.should_receive(:class).twice.and_return(Net::HTTPBadRequest)

          expect {
            http_probe.sample
          }.to raise_error(RuntimeError, "HTTP request failed, the error class is: Net::HTTPBadRequest")

        end

        it 'triggers an http request that runs into an Exception which gets wrapped into a RuntimeError' do
          http_probe = HttpProbe.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil)
          http_probe.instance_variable_set(:@proxy, http_proxy)

          http_proxy.should_receive(:request).and_raise(Exception.new('some message'))

          expect {
            http_probe.sample
          }.to raise_error(RuntimeError, "#sample caught an Exception of class Exception with message: some message")

        end

        it 'activates ssl-mode when given URL has https scheme' do
          http_probe = HttpProbe.new('https://example.com/resource?id=1&token=asldfhljdhru74', nil)
          http_probe.instance_variable_set(:@proxy, http_proxy)

          http_proxy.should_receive(:use_ssl=).with(true).once
          http_proxy.should_receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE).once
          http_proxy.should_receive(:request).and_return(http_response)
          http_response.should_receive(:class).once.and_return(Net::HTTPOK)

          http_probe.sample
        end

        it 'activates basic authentication when given URL contains userinfo' do
          http_probe = HttpProbe.new('http://user:password@example.com/resource?id=1&token=asldfhljdhru74', nil)
          http_probe.instance_variable_set(:@proxy, http_proxy)
          uri = http_probe.instance_variable_get(:@uri)

          Net::HTTP::Get.should_receive(:new).with(uri.request_uri).once.and_return(http_request)
          http_request.should_receive(:basic_auth).with('user', 'password').once
          http_proxy.should_receive(:request).and_return(http_response)
          http_response.should_receive(:class).once.and_return(Net::HTTPOK)

          http_probe.sample
        end

      end


      describe '#satisfied?' do

        let(:matcher) { double('matcher') }
        let(:http_response) { double('http_response') }

        it 'sends a #matches? message to its matcher and receives true' do
          http_probe = HttpProbe.new('http://example.com/resource?id=1&token=asldfhljdhru74', matcher)
          http_probe.instance_variable_set(:@http_response, http_response)

          http_response.should_receive(:nil?).and_return(false)
          http_response.should_receive(:body)

          matcher.should_receive(:matches?).once.and_return(true)

          http_probe.satisfied?.should be_true
        end

      end

    end

  end
end