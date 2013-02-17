# This module handles the generic bits of the poller gem and
# is intended to be mixed into any concrete Poller implementations
# The generic parts include the periodic checking of a Probe and
# raising a RuntimeError in case the timeout period has been exceeded

module Poller
  module Poller

    def initialize(probe, timeout_s, period_s)
      @probe = probe
      @timeout_s = timeout_s
      @period_s = period_s
    end

    def check
      # comment on testability
      @timeout ||= Timeout.new(@timeout_s)

      while !@probe.satisfied?
        raise RuntimeError, 'Timeout period has been exceeded' if @timeout.occured?
        Kernel.sleep @period_s
      end
    end

  end
end