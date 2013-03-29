# This module handles the generic bits of the poller gem and
# is intended to be mixed into any concrete Poller implementations
# The generic parts include the periodic checking of a Probe and
# raising a RuntimeError in case the timeout period has been exceeded.
#
# Poller expects that the probe object has methods called 'satisfied?'
# which will return a boolean and 'sample' which triggers taking the
# next sample and has no explicit return value.

require 'poller/timeout'

module Poller
  module Poller

    def initialize(probe, timeout_seconds, period_seconds, name = nil)
      @probe = probe
      @timeout_seconds = timeout_seconds
      @period = period_seconds.to_f
      @name = name.nil? ? "no name given" : name
    end

    def check
      @timeout ||= Timeout.new(@timeout_seconds) # allow injecting a Timeout object from within tests

      tries = 0
      check_started_at = Time.now
      last_sample_took = 0

      while !@timeout.occured?
        Kernel.sleep sleep_time(@period, last_sample_took)
        sample_started_at = Time.now
        @probe.sample
        satisfied = @probe.satisfied?
        last_sample_took = Time.now - sample_started_at
        tries += 1
        return if satisfied
      end

      raise RuntimeError, "Timeout period has been exceeded for Poller (#{@name})." \
        + " Poller tried #{tries} times which in total took #{Time.now - check_started_at} seconds."
    end

    private
    def sleep_time(period, last_sample_took)
      st = period - last_sample_took
      st < 0 ? 0 : st
    end

  end
end