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

        it 'returns true if a given String is contained at given XPath within the XML document' do
          xct = XPathContainsText.new('//A/B', 'humpty')

          xct.matches?(sample_xml_string).should be_true
        end

        it 'returns true if a given Regex matches the text at given XPath within the XML document' do
          xct = XPathContainsText.new('//A/B', /ump/)

          xct.matches?(sample_xml_string).should be_true
        end

        it 'returns false if the XML document does not contain the specified node' do
          xct = XPathContainsText.new('//C/B', /ump/)

          xct.matches?(sample_xml_string).should be_false
        end

      end

    end
  end
end
