require 'journey_log'

describe JourneyLog do
  subject(:journey_log) { described_class.new }
  let(:journey) { double :journey, :entry_station => station }
  let(:entry_station) { double :station}
  describe '#start_journey' do
    it 'should start a new journey with an entry station' do
      journey_log.start_journey(entry_station)
      expect(journey_log.journey).not_to be_nil
    end
  end

end
