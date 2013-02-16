class Timeout

  # Specify the timeout period in Integer or Floating Point representation
  # +period_s+:: The timeout period in seconds
  def initialize(period_s)
    @period = period_s
    @start_time = Time.now
  end

  # Returns true if timeout period has elapsed, false if not
  def occured?
    Time.now - @start_time > @period
  end

end