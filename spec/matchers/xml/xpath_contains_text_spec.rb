require 'spec_helper'
require 'matchers/xml/xpath_contains_text'

module Matchers
  module XML

    describe XPathContainsText do

      def sample_xml_string
        <<-EOF
        <?xml version='1.0' encoding='UTF-8'?>
        <A id='dumpty'>
          <B>humpty</B>
        </A>
        EOF
      end

      context '#matches?' do

        let(:http_response) { double('http_response') }

        it 'returns true if a given String is contained at given XPath within the XML document parsed from response.body' do
          http_response.stub(:body).and_return(sample_xml_string)

          xct = XPathContainsText.new('//A/B', 'humpty')

          xct.matches?(http_response).should be_true
        end

        it 'returns true if a given Regex matches the text at given XPath within the XML document parsed from response.body' do
          http_response.stub(:body).and_return(sample_xml_string)

          xct = XPathContainsText.new('//A/B', /ump/)

          xct.matches?(http_response).should be_true
        end

      end

    end
  end
end
