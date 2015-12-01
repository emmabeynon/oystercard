

class Oystercard

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance, :entry_station

  def initialize
    @balance = DEFAULT_BALANCE
  end

  def top_up(amount)
    fail "The £#{MAX_BALANCE} maximum limit would be exceeded!" if limit_reached?(amount)
    @balance += amount
  end

  def limit_reached?(amount)
    (@balance + amount) >= 90
  end


  def touch_in(station)
    fail "Insufficient funds: you need at least £#{MIN_FARE} to travel" if insufficient_funds?
    @entry_station = station
  end

  def touch_out
    deduct(MIN_FARE)
    @entry_station = nil
  end

  def in_journey?
    @entry_station != nil
  end

private
  def insufficient_funds?
    @balance < MIN_FARE
  end

  def deduct(amount)
    @balance -= amount
  end


end
