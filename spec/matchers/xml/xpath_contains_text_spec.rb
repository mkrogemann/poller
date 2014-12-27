require 'spec_helper'
require 'matchers/xml/xpath_contains_text'

module Matchers
  module XML
    describe XPathContainsText do
      describe '#matches?' do

        context 'node value matches given search String' do
          it 'true if given String is contained at given XPath within the XML' do
            xct = XPathContainsText.new('//A/B', 'humpty')
            expect(xct.matches?(simple_valid_xml)).to be_truthy
          end
        end

        context 'node value matches given Regex' do
          it 'true if a given Regex matches the text at given XPath within the XML' do
            xct = XPathContainsText.new('//A/B', /ump/)
            expect(xct.matches?(simple_valid_xml)).to be_truthy
          end
        end

        context 'node not contained in XML' do
          it 'false if the XML document does not contain the specified node' do
            xct = XPathContainsText.new('//C/B', /ump/)
            expect(xct.matches?(simple_valid_xml)).to be_falsey
          end
        end

        context 'invalid XML' do
          it 'raises a REXML::ParseException for invalid XML' do
            xct = XPathContainsText.new('//C/B', /ump/)
            invalid_xml = simple_valid_xml[0..-3]
            expect {
              xct.matches?(invalid_xml)
            }.to raise_error REXML::ParseException
          end
        end
      end
    end
  end
end
