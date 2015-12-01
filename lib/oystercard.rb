

class Oystercard

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance

  def initialize
    @balance = DEFAULT_BALANCE
    @in_use = false
  end

  def top_up(amount)
    fail "The £#{MAX_BALANCE} maximum limit would be exceeded!" if limit_reached?(amount)
    @balance += amount
  end

  def limit_reached?(amount)
    (@balance + amount) >= 90
  end


  def touch_in
    fail "Insufficient funds: you need at least £#{Oystercard::MIN_FARE} to travel" if insufficient_funds?
    @in_use = true
  end

  def touch_out
    @in_use = false
    deduct
  end

  def in_journey?
    @in_use
  end

private
  def insufficient_funds?
    @balance < MIN_FARE
  end

  def deduct
    @balance -= MIN_FARE
  end


end
