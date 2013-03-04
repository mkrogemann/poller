require 'spec_helper'
require 'matchers/http/response_body_contains'

module Matchers
  module HTTP

    describe ResponseBodyContains do

      context '#matches?' do

        let(:http_response) { double('http_response') }

        it 'returns true if a given String is contained in response.body' do
          http_response.stub(:body).and_return("some too long to read char noise")

          rbc = ResponseBodyContains.new('ng to read cha')

          rbc.matches?(http_response).should be_true
        end

        it 'matches a given Regexp with response.body (happy case)' do
          http_response.stub(:body).and_return("some too long to read char noise")

          rbc = ResponseBodyContains.new(/oo/)

          rbc.matches?(http_response).should be_true
        end

        it 'matches a given Regexp with response.body (no match)' do
          http_response.stub(:body).and_return("some too long to read char noise")

          rbc = ResponseBodyContains.new(/o ln/)

          rbc.matches?(http_response).should be_false
        end
      end

    end

  end
end
