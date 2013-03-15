require 'spec_helper'
require 'matchers/xml/document_contains_xpath'

module Matchers
  module XML

    describe DocumentContainsXPath do

      def sample_xml_string
        <<-EOF
        <?xml version='1.0' encoding='UTF-8'?>
        <Agents>
          <Agent>001</Agent>
          <Agent>002</Agent>
        </Agents>
        EOF
      end

      context '#matches?' do

        let(:http_response) { double('http_response') }

        it 'returns true if a given XPath is contained at least once within the XML document' do

          http_response.stub(:body).and_return(sample_xml_string)

          dcx = DocumentContainsXPath.new('/Agents')

          dcx.matches?(http_response).should be_true
        end

        it 'returns true if a given XPath is contained at least given number of times within the XML document' do

          http_response.stub(:body).and_return(sample_xml_string)

          dcx = DocumentContainsXPath.new('/Agents/Agent', 2)

          dcx.matches?(http_response).should be_true
        end

        it 'returns false if a given XPath is contained fewer times than specified' do

          http_response.stub(:body).and_return(sample_xml_string)

          dcx = DocumentContainsXPath.new('/Agents/Agent', 3)

          dcx.matches?(http_response).should be_false
        end

      end

    end

  end
end
