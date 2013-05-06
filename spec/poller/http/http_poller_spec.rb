require 'spec_helper'
require 'poller/http/http_poller'
require 'ostruct'

module Poller
  module HTTP
    describe HttpPoller do
      describe '#initialize' do
        context 'HttpProbe from URL' do
          it 'constructs an HttpPoller with an HttpProbe constructed from a URL' do
            http_poller = HttpPoller.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil, Float::MAX,Float::MIN)
            probe = http_poller.instance_variable_get(:@probe)
            probe.class.should == HttpProbe
          end
        end

        context 'HttpProbe with Proxy from OpenStruct' do
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

        context 'HttpProbe with Proxy from Hash' do
          it 'constructs an HttpPoller with Proxy information given in a Hash' do
            proxy = { :hostname => 'proxy.internal.com', :port => 8080, :user => 'user', :password => '_secret' }
            http_poller = HttpPoller.new('http://example.com/resource?id=1&token=asldfhljdhru74', nil, Float::MAX, Float::MIN, proxy)
            probe = http_poller.instance_variable_get(:@probe)
            probe_proxy = probe.instance_variable_get(:@proxy)
            probe_proxy.proxy_pass.should == '_secret'
          end
        end
      end

      # integration tests...
      describe '#check' do
        context 'respponse_body_contains' do
          require 'matchers/http/response_body_contains'
          it 'succeeds in fetching and matching an http response from example.com', :type => 'integration' do
            matcher = Matchers::HTTP::ResponseBodyContains.new('<title>Example Domain</title>')
            poller = HttpPoller.new("http://example.iana.org", matcher, 5.0, 1.0)
            poller.check.should be_nil
          end
        end

        context 'xpath_contains_text' do
          require 'matchers/xml/xpath_contains_text'
          it 'succeeds in fetching an XML document and in finding a text for given XPath', :type => 'integration' do
            matcher = Matchers::XML::XPathContainsText.new('/CATALOG/CD/TITLE', 'Empire Burlesque')
            poller = HttpPoller.new("http://www.w3schools.com/xml/cd_catalog.xml", matcher, 5.0, 1.0)
            poller.check.should be_nil
          end

          # make sure non-existing nodes do not trigger any problems
          it 'eventually runs into timeout when looking for non-existing text node', :type => 'integration' do
            matcher = Matchers::XML::XPathContainsText.new('/CATALOG/SCHELLACK/TITLE', 'Empire Burlesque')
            poller = HttpPoller.new("http://www.w3schools.com/xml/cd_catalog.xml", matcher, 5.0, 1.0)
            expect {
              poller.check
            }.to raise_error(RuntimeError, /^Timeout period has been exceeded for Poller \(http:\/\/www.w3schools.com\/xml\/cd_catalog.xml\)\. Poller tried \d times which in total took \d\.?\d* seconds\.$/)
          end
        end

        context 'document_contains_xpath' do
          require 'matchers/xml/document_contains_xpath'
          it 'succeeds in fetching an XML document and in finding a given XPath at least given number of times', :type => 'integration' do
            matcher = Matchers::XML::DocumentContainsXPath.new('/CATALOG/CD/ARTIST', 11)
            poller = HttpPoller.new("http://www.w3schools.com/xml/cd_catalog.xml", matcher, 5.0, 1.0)
            poller.check.should be_nil
          end

          # have a failing test to validate error message
          it 'fails to find a given XPath in document', :type => 'integration' do
            matcher = Matchers::XML::DocumentContainsXPath.new('/CATALOG/NOT_THERE/LIGHT', 11)
            poller = HttpPoller.new("http://www.w3schools.com/xml/plant_catalog.xml", matcher, 5.0, 1.0)
            expect {
              poller.check
            }.to raise_error(RuntimeError, /^Timeout period has been exceeded for Poller \(http:\/\/www.w3schools.com\/xml\/plant_catalog.xml\)\. Poller tried \d times which in total took \d\.?\d* seconds\.$/)
          end
        end
      end
    end
  end
end

