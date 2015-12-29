require 'journey'

describe Journey do
  subject(:journey) { described_class.new(london_bridge) }
  let(:forest_hill) { double :station, name: "Forest Hill", zone: 3 }
  let(:brockley) { double :station, name: "Brockley", zone: 2 }
  let(:london_bridge) { double :station, name: "London Bridge", zone: 1 }
  let(:oxford_circus) { double :station, name: "Oxford Circus", zone: 1 }

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
      allow(journey).to receive(:entry_station) { "No station recorded"}
      journey.fare_calculation
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it 'returns a penalty fare if exit station is nil' do
      allow(journey).to receive(:exit_station) { "No station recorded"}
      journey.fare_calculation
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it 'returns a calculated fare if entry and exit station are both set' do
      journey.complete_journey(brockley)
      expect(journey.fare).to eq 2
    end
  end

  describe '#zone_calculation' do
    it 'calculates fare for journey in zone 1 only' do
      journey.complete_journey(oxford_circus)
      expect(journey.fare).to eq 1
    end

    it 'calculates fare for journey from zone 1 to zone 3' do
      journey.complete_journey(forest_hill)
      expect(journey.fare).to eq 3
    end

    it 'calculates fare for journey from zone 3 to zone 2' do
      journey_2 = Journey.new(forest_hill)
      journey.complete_journey(brockley)
      expect(journey.fare).to eq 2
    end
  end

  describe '#complete_journey' do
    it 'sets exit_station' do
      journey.complete_journey(brockley)
      expect(journey.exit_station).to eq brockley
    end
  end

end
