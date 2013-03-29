module Poller
  class Timeout

    # Specify the timeout period in Integer or Floating Point representation
    # +period_seconds+:: The timeout period in seconds
    def initialize(period_seconds)
      @period = period_seconds
      @start_time = Time.now
    end

    # Returns true if timeout period has elapsed, false if not
    def occured?
      Time.now - @start_time >= @period
    end

  end
end
