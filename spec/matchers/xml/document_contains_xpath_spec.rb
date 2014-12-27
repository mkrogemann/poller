require 'spec_helper'
require 'matchers/xml/document_contains_xpath'

module Matchers
  module XML
    describe DocumentContainsXPath do
      describe '#matches?' do

        context 'the document contains what we look for' do
          it 'true if given XPath is contained at least once within the XML' do
            dcx = DocumentContainsXPath.new('/Agents')
            expect(dcx.matches?(two_agents_xml)).to be_truthy
          end

          it 'true if given XPath contained at least given number of times within the XML' do
            dcx = DocumentContainsXPath.new('/Agents/Agent', 2)
            expect(dcx.matches?(two_agents_xml)).to be_truthy
          end
        end

        context 'the document does not contain what we look for' do
          it 'false if given XPath is contained fewer times than specified' do
            dcx = DocumentContainsXPath.new('/Agents/Agent', 3)
            expect(dcx.matches?(two_agents_xml)).to be_falsey
          end
        end

        context 'invalid XML' do
          it 'raises a REXML::ParseException for invalid XML' do
            dcx = DocumentContainsXPath.new('/Agents/Agent', 3)
            invalid_xml = two_agents_xml[0..-3]
            expect {
              dcx.matches?(invalid_xml)
            }.to raise_error REXML::ParseException
          end
        end
      end
    end
  end
end
