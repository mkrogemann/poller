require 'spec_helper'
require 'matchers/http/response_body_contains'

module Matchers
  module HTTP

    describe ResponseBodyContains do

      context '#matches?' do

        it 'returns true if the search String is contained in String passed to matches? method' do
          rbc = ResponseBodyContains.new('ng to read cha')

          rbc.matches?("some too long to read char noise").should be_true
        end

        it 'matches a given Regexp with given Sting (happy case)' do
          rbc = ResponseBodyContains.new(/oo/)

          rbc.matches?("some too long to read char noise").should be_true
        end

        it 'matches a given Regexp with given String (no match case)' do
          rbc = ResponseBodyContains.new(/o ln/)

          rbc.matches?("some too long to read char noise").should be_false
        end
      end

    end

  end
end
