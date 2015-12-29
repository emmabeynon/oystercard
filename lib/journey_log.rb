require_relative 'journey'

class JourneyLog
  attr_reader :journey, :journey_klass, :journey_history

  def initialize(journey_klass=Journey)
    @journey_klass = journey_klass
    @journey_history = []
    @journey == nil
  end

  def start_journey(entry_station)
    @journey = journey_klass.new(entry_station)
  end

  def exit_journey(exit_station)
    @journey = journey_klass.new("No station recorded") if @journey == nil
    journey.complete_journey(exit_station)
    record_journey(journey)
    @journey = nil
  end

  def journeys
    journey_history
  end

  def outstanding_charges
    exit_journey("No station recorded") if journey.exit_station == nil
    last_journey_fare
  end

  def last_journey_fare
    journey_history.last.fare
  end


  private

  def in_journey?
    if @journey != nil
      true
    else
      false
    end
  end

  def record_journey(journey)
    @journey_history << journey
  end

end
