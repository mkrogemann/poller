require 'spec_helper'
require 'matchers/xml/document_contains_xpath'

module Matchers
  module XML
    describe DocumentContainsXPath do
      describe '#matches?' do

        context 'the document contains what we look for' do
          it 'true if given XPath is contained at least once within the XML' do
            dcx = DocumentContainsXPath.new('/Agents')
            dcx.matches?(two_agents_xml).should be_true
          end

          it 'true if given XPath contained at least given number of times within the XML' do
            dcx = DocumentContainsXPath.new('/Agents/Agent', 2)
            dcx.matches?(two_agents_xml).should be_true
          end
        end

        context 'the document does not contain what we look for' do
          it 'false if given XPath is contained fewer times than specified' do
            dcx = DocumentContainsXPath.new('/Agents/Agent', 3)
            dcx.matches?(two_agents_xml).should be_false
          end
        end
      end
    end
  end
end
