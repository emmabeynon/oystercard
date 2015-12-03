require 'journey'

describe Journey do
  subject(:journey) { described_class.new("King's Cross") }
  # let(:entered_station) {double :station}
  # let(:exited_station) {double :station}

  it 'responds to entry_station' do
    expect(journey).to respond_to :entry_station
  end

  it 'defaults to nil if entry_station argument not passed' do
    journey = Journey.new
    expect(journey.entry_station).to be_nil
  end

  it 'responds to exit_station' do
    expect(journey).to respond_to :exit_station
  end

  describe '#fare_calculation' do
    it 'returns PENALTY_FARE if entry station is nil' do
      entry_station = nil
      journey.fare_calculation
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it 'returns PENALTY_FARE if exit station is nil' do
      exit_station = nil
      journey.fare_calculation
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it 'returns MIN_FARE if entry and exit station are both set' do
      journey = Journey.new("kings cross")
      journey.complete_journey("whitechapel")
      journey.fare_calculation
      expect(journey.fare).to eq Journey::MIN_FARE
    end
  end

  describe '#complete_journey' do
    it 'sets exit_station' do
      journey = Journey.new("kings cross")
      journey.complete_journey("whitechapel")
      expect(journey.exit_station).to eq "whitechapel"
    end
  end

  it 'respond to complete_journey' do
    expect(journey).to respond_to :complete_journey
  end
end
