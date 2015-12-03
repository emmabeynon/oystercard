
require_relative 'journey'

class Oystercard

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90

  attr_reader :balance, :entry_station, :exit_station, :journey_history,
    :journey

  def initialize
    @balance = DEFAULT_BALANCE
    @journey_history = []
    @journey = nil
  end

  def top_up(amount)
    fail "£#{MAX_BALANCE} balance limit exceeded. Choose a smaller amount." if
      limit_reached?(amount)
    @balance += amount
  end

  def touch_in(station)
    deduct(journey.fare_calculation) if journey != nil
    fail "Can't touch in: you need at least £#{Journey::MIN_FARE} to travel" if
      insufficient_funds?
    @journey = Journey.new(station)
  end

  def touch_out(station)
    @journey = Journey.new if @journey == nil
    journey.complete_journey(station)
    deduct(journey.fare_calculation)
    journey_history << journey
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

  def in_journey?
    !!entry_station
  end

end
