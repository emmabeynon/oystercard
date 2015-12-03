require 'journey'

describe Journey do
  subject(:journey) { described_class.new(:entered_station) }
  let(:entered_station) {double :station}
  let(:exited_station) {double :station}

  describe '#default' do
    it 'has a penalty fare by default' do
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it 'defaults to nil if entry_station argument not passed' do
      journey = described_class.new
      expect(journey.entry_station).to be_nil
    end
  end

  describe '#fare_calculation' do
    it 'returns a penalty fare if entry station is nil' do
      entry_station = nil
      journey.fare_calculation
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it 'returns a penalty fare if exit station is nil' do
      exit_station = nil
      journey.fare_calculation
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it 'returns MIN_FARE if entry and exit station are both set' do
      journey.complete_journey(exited_station)
      journey.fare_calculation
      expect(journey.fare).to eq Journey::MIN_FARE
    end
  end

  describe '#complete_journey' do
    it 'sets exit_station' do
      journey.complete_journey(exited_station)
      expect(journey.exit_station).to eq exited_station
    end
  end

end
