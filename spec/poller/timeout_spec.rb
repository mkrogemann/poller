require 'spec_helper'
require 'poller/timeout'

module Poller
  describe Timeout do

    context '#occured?' do

      it 'returns true if timeout period has expired' do
        Timeout.new(-1.8).occured?.should be_true
      end

      it 'returns false as long as timeout period has not expired' do
        Timeout.new(Float::MAX).occured?.should be_false
      end

    end

  end
end
