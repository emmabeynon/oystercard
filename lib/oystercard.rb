require_relative 'journey_log'

class Oystercard

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90

  attr_reader :balance, :journey, :journey_log

  def initialize(journey_log_klass=JourneyLog)
    @balance = DEFAULT_BALANCE
    @journey_log = journey_log_klass.new
  end

  def top_up(amount)
    fail "£#{MAX_BALANCE} balance limit exceeded. Choose a smaller amount." if
      limit_reached?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Can't touch in: you need at least £#{Journey::MIN_FARE} to travel" if
      insufficient_funds?
    journey_log.start_journey(station)
  end

  def touch_out(station)
    journey_log.exit_journey(station)
    deduct(journey_log.last_journey_fare)
  end

  def incomplete_journey
    deduct(journey_log.outstanding_charges)
  end

private

  def insufficient_funds?
    balance < Journey::MIN_FARE
  end

  def deduct(amount)
    @balance -= amount
  end

  def limit_reached?(amount)
    (balance + amount) >= MAX_BALANCE
  end
end
