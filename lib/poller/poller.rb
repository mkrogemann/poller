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
      @tries = 0
    end

    def check
      @timeout ||= Timeout.new(@timeout_s)
      @start_time ||= Time.now

      while !@timeout.occured?
        Kernel.sleep @period_s
        @probe.sample
        @tries +=1
        return if @probe.satisfied?
      end

      raise RuntimeError, "Timeout period has been exceeded for Poller (#{@name})." \
        + " Poller tried #{@tries} times which in total took #{Time.now - @start_time} seconds."

    end

  end
end