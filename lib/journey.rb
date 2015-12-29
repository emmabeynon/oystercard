class Journey
  attr_reader :entry_station, :exit_station, :fare

  PENALTY_FARE = 6
  MIN_FARE = 1

  def initialize(entry_station=nil)
    @entry_station = entry_station
    @exit_station = nil
    @fare = PENALTY_FARE
  end

  def fare_calculation
     complete? ? @fare = MIN_FARE : @fare = PENALTY_FARE
  end

  def complete_journey(station)
    @exit_station = station
    fare_calculation
  end

  private

  def complete?
    entry_station != "No station recorded" && exit_station != "No station recorded"
  end
end
