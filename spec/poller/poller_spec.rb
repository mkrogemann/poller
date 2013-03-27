require 'spec_helper'
require 'poller/poller'

module Poller


  # we need a class to include the module into so we can test its behaviour
  class PollerModuleHolder
    include Poller

    def initialize(probe, matcher, timeout_s, period_s, name = nil)
      super(probe, timeout_s, period_s, name)
    end
  end


  describe Poller do

    let(:timeout) { double('timeout') }
    let(:probe) { double('probe') }

    context '#check' do

      it 'succeeds immediately (probe is satisfied on first call)' do
        timeout.stub(:occured?).and_return(false)
        probe.stub(:satisfied?).and_return(true)

        # sleep/sample/satisfied? called exactly once
        probe.should_receive(:satisfied?).once
        Kernel.should_receive(:sleep).once
        probe.should_receive(:sample).once

        # matcher, timeout_s and period_s are nil, they are out of this example's scope (mocked)
        poller = PollerModuleHolder.new(probe, nil, nil, nil)
        poller.instance_variable_set(:@timeout, timeout)

        poller.check
      end


      it 'succeeds after taking the third sample' do
        probe.stub(:satisfied?).and_return(false, false, true)
        timeout.stub(:occured?).and_return(false, false, false)

        # sleep should have been called twice, probe.satisfied? thrice
        Kernel.should_receive(:sleep).exactly(3).times
        probe.should_receive(:sample).exactly(3).times
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
        probe.should_receive(:satisfied?).once

        # we set matcher and timeout_s to nil as it is out of this example's scope (and because we mock it)
        poller = PollerModuleHolder.new(probe, nil, nil, 0.0001, 'descriptive name here')
        poller.instance_variable_set(:@timeout, timeout)

        expect {
          poller.check
        }.to raise_error(RuntimeError, /^Timeout period has been exceeded for Poller \(descriptive name here\)\. Poller tried \d times which in total took .* seconds\.$/)
      end

    end

  end
end
