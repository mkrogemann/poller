# This module handles the generic bits of the poller gem and
# is intended to be mixed into any concrete Poller implementations
# The generic parts include the periodic checking of a Probe and
# raising a RuntimeError in case the timeout period has been exceeded.
#
# Poller expects that the probe object has methods called 'satisfied?'
# that will return a boolean and 'sample' which takes the next sample
# and has no explicit return value.

require 'poller/timeout'

module Poller
  module Poller

    def initialize(probe, timeout_s, period_s, name = nil)
      @probe = probe
      @timeout_s = timeout_s
      @period_s = period_s
      @name = name.nil? ? "no name given" : name
    end

    def check
      # This following line allows us to inject a timeout object from within our tests
      @timeout ||= Timeout.new(@timeout_s)

      while !@probe.satisfied?
        raise RuntimeError, "Timeout period has been exceeded for Poller (#{@name})" if @timeout.occured?
        Kernel.sleep @period_s

        @probe.sample
      end


    end

  end
end