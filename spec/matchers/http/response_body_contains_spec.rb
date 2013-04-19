require 'spec_helper'
require 'matchers/http/response_body_contains'

module Matchers
  module HTTP
    describe ResponseBodyContains do
      describe '#matches?' do
        context 'search term contained in document' do
          it 'true if search String is contained in String passed to matches? method' do
            rbc = ResponseBodyContains.new('ng to read cha')
            rbc.matches?("some too long to read char noise").should be_true
          end

          it 'true if given Regexp matches given Sting' do
            rbc = ResponseBodyContains.new(/oo/)
            rbc.matches?("some too long to read char noise").should be_true
          end
        end

        context 'search term not contained in document' do
          it 'false if given Regexp does not match given String' do
            rbc = ResponseBodyContains.new(/o ln/)
            rbc.matches?("some too long to read char noise").should be_false
          end
        end
      end
    end
  end
end
