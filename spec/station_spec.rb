require 'station'

describe Station do
  subject(:station) {described_class.new("Whitechapel", 2)}

    it 'has a name variable' do
      expect(station.name).to eq("Whitechapel")
    end

    it 'has a zone variable' do
      expect(station.zone).to eq(2)
    end
end
