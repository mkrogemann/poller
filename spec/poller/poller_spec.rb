require 'spec_helper'
require 'poller/poller'

module Poller


  # we need a class to include the module into so we can test its behaviour
  class PollerModuleHolder
    include Poller

    def initialize(probe, matcher, timeout_s, period_s)
      super(probe, timeout_s, period_s)
    end
  end


  describe Poller do

    let(:timeout) { double('timeout') }
    let(:probe) { double('probe') }

    context '#check' do

      it 'succeeds immediately (probe is satisfied on first call)' do
        probe.should_receive(:satisfied?).once.and_return(true)
        # we want to test that the sleep and sample methods never get executed
        Kernel.should_not_receive(:sleep)
        probe.should_not_receive(:sample)

        # we set matcher, timeout_s and period_s to nil as they are out of this example's scope. no need
        # to use the timeout mock here as it will not get called because first poll already succeeds
        PollerModuleHolder.new(probe, nil, nil, nil).check
      end


      it 'succeeds after taking the third sample' do
        probe.stub(:satisfied?).and_return(false, false, true)
        timeout.stub(:occured?).and_return(false, false, false)

        # sleep should have been called twice, probe.satisfied? thrice
        Kernel.should_receive(:sleep).twice
        probe.should_receive(:sample).twice
        probe.should_receive(:satisfied?).exactly(3).times

        # we set matcher and timeout_s to nil as it is out of this example's scope (and because we mock it)
        poller = PollerModuleHolder.new(probe, nil, nil, 0.0001)
        poller.instance_variable_set(:@timeout, timeout)

        poller.check
      end


      it 'raises a RuntimeError if probe remains unsatisfied while timeout occurs' do
        probe.stub(:satisfied?).and_return(false, false)
        timeout.stub(:occured?).and_return(false, true)

        # sleep should have been called once
        Kernel.should_receive(:sleep).once
        probe.should_receive(:sample).once
        probe.should_receive(:satisfied?).exactly(:twice)

        # we set matcher and timeout_s to nil as it is out of this example's scope (and because we mock it)
        poller = PollerModuleHolder.new(probe, nil, nil, 0.0001)
        poller.instance_variable_set(:@timeout, timeout)

        expect {
          poller.check
        }.to raise_error(RuntimeError, /^Timeout period has been exceeded$/)
      end

    end

  end
end
