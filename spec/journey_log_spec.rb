require 'journey_log'

describe JourneyLog do
  subject(:journey_log) { described_class.new(journey_klass) }
  let(:journey) { double :journey, fare: 6 }
  let(:journey_klass) { double :journey_klass, new: journey, exit_station: exit_station}
  let(:entry_station) { double :station}
  let(:exit_station) { double :station}

  describe '#default' do
    it "has a an empty list of journeys" do
      expect(journey_log.journey_history).to be_empty
    end

    it 'has no active journey' do
      expect(journey_log.journey).to be_nil
    end
  end

  describe '#start_journey' do
    before do
      journey_log.start_journey(entry_station)
    end

    it 'creates a new journey' do
      expect(journey_log.journey).to eq journey
    end
  end

  describe '#exit_journey' do
    before do
      allow(journey).to receive(:complete_journey).and_return exit_station
      allow(journey).to receive(:exit_station).and_return exit_station
      journey_log.start_journey(entry_station)
      journey_log.exit_journey(exit_station)
    end

    it 'should record the journey' do
      expect(journey_log.journey_history).to include(journey)
    end

    it 'should reset journey to nil after completing a journey' do
      expect(journey_log.journey).to be_nil
    end
  end

  describe '#journeys' do
    it 'returns a list of all previous journeys' do
      allow(journey).to receive(:complete_journey).and_return exit_station
      journey_log.start_journey(entry_station)
      journey_log.exit_journey(exit_station)
      expect(journey_log.journey_history).to include(journey)
    end
  end

  describe '#last_journey_fare' do
    it 'returns the fare from an completed journey' do
      journey_log.start_journey(entry_station)
      allow(journey).to receive(:complete_journey).and_return exit_station
      allow(journey).to receive(:fare).and_return 1
      journey_log.exit_journey(exit_station)
      expect(journey_log.last_journey_fare).to eq 1
    end
  end
end
