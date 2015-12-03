class Journey
  attr_reader :entry_station, :exit_station, :fare

  PENALTY_FARE = 6
  MIN_FARE = 1

  def initialize(entry_station=nil)
    @entry_station = entry_station
    @exit_station = nil
    @journey = {}
    @fare = MIN_FARE
  end

  def fare_calculation
    entry_station == nil || exit_station == nil ?
      @fare = PENALTY_FARE : @fare = MIN_FARE
  end

  def complete_journey(station)
    @exit_station = station
  end

end
