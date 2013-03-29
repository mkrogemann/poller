require 'spec_helper'
require 'poller/poller'

module Poller


  # we need a class to include the module into so we can test its behaviour
  class PollerModuleHolder
    include Poller

    def initialize(probe, timeout_seconds, period_seconds, name = nil)
      super(probe, timeout_seconds, period_seconds, name)
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

        # we can set timeout_seconds to nil since Timeout gets mocked
        poller = PollerModuleHolder.new(probe, nil, 0.1, nil)
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

        # we can set timeout_seconds to nil since Timeout gets mocked
        poller = PollerModuleHolder.new(probe, nil, 0.1, nil)
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

        # we can set timeout_seconds to nil since Timeout gets mocked
        poller = PollerModuleHolder.new(probe, nil, 0.1, 'descriptive name here')
        poller.instance_variable_set(:@timeout, timeout)

        expect {
          poller.check
        }.to raise_error(RuntimeError, /^Timeout period has been exceeded for Poller \(descriptive name here\)\. Poller tried \d times which in total took .* seconds\.$/)
      end

    end

  end
end
