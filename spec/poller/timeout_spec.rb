require 'spec_helper'
require 'poller/timeout'

module Poller
  describe Timeout do
    context '#occured?' do

      it 'returns true if timeout period has expired' do
        expect(Timeout.new(-1.8).occured?).to be_truthy
      end

      it 'returns false as long as timeout period has not expired' do
        expect(Timeout.new(Float::MAX).occured?).to be_falsey
      end
    end
  end
end
