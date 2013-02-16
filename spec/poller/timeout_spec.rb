require 'spec_helper'
require 'poller/timeout'

describe Timeout do

  context '#occured?' do

    it 'returns true if timeout period has expired' do
      Timeout.new(-1.8).occured?.should be_true
    end

    it 'returns false before timeout period has expired' do
      Timeout.new(Float::MAX).occured?.should be_false
    end

  end

end