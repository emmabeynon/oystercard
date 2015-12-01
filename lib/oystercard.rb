

class Oystercard

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 1000

  attr_reader :balance

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

end
