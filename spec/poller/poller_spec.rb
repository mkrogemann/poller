require 'spec_helper'
require 'poller/poller'

module Poller


  # we need a class to include the module into so we can test its behaviour
  class PollerModuleHolder
    include Poller

    def initialize(probe, timeout_s, period_s)
      super
    end
  end


  describe Poller do

    let(:timeout) { double('timeout') }
    let(:probe) { double('probe') }

    context '#check' do

      it 'succeeds after 1 poll' do
        probe.stub(:satisfied?).and_return(true)

        # we want to test that the sleep method never gets executed
        Kernel.should_not_receive(:sleep)

        # we set timeout_s and period_s to nil as they are out of this example's scope. no need
        # to use the timeout mock here as it will not get called because first poll already succeeds
        PollerModuleHolder.new(probe, nil, nil).check
      end


      it 'succeeds after 3 polls' do
        probe.stub(:satisfied?).and_return(false, false, true)
        timeout.stub(:occured?).and_return(false, false, false)

        # sleep should have been called twice
        Kernel.should_receive(:sleep).twice

        # we set timeout_s to nil as it is out of this example's scope (and because we mock it)
        poller = PollerModuleHolder.new(probe, nil, 0.0001)
        poller.instance_variable_set(:@timeout, timeout)

        poller.check
      end


      it 'raises a RuntimeError if probe remains unsatisfied while timeout occurs' do
        probe.stub(:satisfied?).and_return(false, false)
        timeout.stub(:occured?).and_return(false, true)

        # sleep should have been called once
        Kernel.should_receive(:sleep).once

        # we set timeout_s to nil as it is out of this example's scope (and because we mock it)
        poller = PollerModuleHolder.new(probe, nil, 0.0001)
        poller.instance_variable_set(:@timeout, timeout)

        expect {
          poller.check
        }.to raise_error(RuntimeError, /^Timeout period has been exceeded$/)
      end

    end

  end
end
