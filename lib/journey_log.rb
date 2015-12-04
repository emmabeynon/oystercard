require_relative 'journey'

class JourneyLog
  attr_reader :journey

  def start_journey(entry_station)
    @journey = Journey.new(entry_station)
  end
end
