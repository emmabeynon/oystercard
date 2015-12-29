require_relative 'station'

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
     complete? ? @fare = zone_calculation : @fare = PENALTY_FARE
  end


  def complete_journey(station)
    @exit_station = station
    fare_calculation
  end

  private

  def complete?
    entry_station != "No station recorded" &&
    exit_station != "No station recorded"
  end

  def zone_calculation
    zones = entry_station.zone - exit_station.zone
    MIN_FARE + zones.abs
  end

end
