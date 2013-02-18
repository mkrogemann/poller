require 'spec_helper'
require 'matchers/http/response_body_contains'

module Matchers
  module HTTP

    describe ResponseBodyContains do

      let(:http_response) { double('http_response') }

      context '#initialze' do

        it 'will take an HTTPResponse object and a string to look for' do
          rbc = ResponseBodyContains.new(http_response, 'some searchstring')
        end

        it 'will take an HTTPResponse object and a Regex to match against' do
          rbc = ResponseBodyContains.new(http_response, /regexen/)
        end

      end


      context '#satisfied?' do

        it 'caompares a given String with response.body' do
          http_response.stub(:body).and_return("some too long to read char noise")

          rbc = ResponseBodyContains.new(http_response, 'ng to read cha')

          rbc.satisfied?.should be_true
        end

        it 'caompares a given Regexp with response.body' do
          http_response.stub(:body).and_return("some too long to read char noise")

          rbc = ResponseBodyContains.new(http_response, /oo/)

          rbc.satisfied?.should be_true
        end
      end

    end

  end
end
