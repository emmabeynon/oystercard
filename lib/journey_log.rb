require_relative 'journey'

class JourneyLog
  attr_reader :journey, :journey_klass

  def initialize(journey_klass)
    @journey_klass = journey_klass
  end

  def start_journey(entry_station)
    @journey = journey_klass.new(entry_station)
  end

  # private

  def current_journey
    journey
  end
end
