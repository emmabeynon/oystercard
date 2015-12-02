require 'oystercard'

describe Oystercard do
subject(:oyster) { described_class.new }
let(:entry_station) {double :station}
let(:exit_station) {double :station}

  describe 'default' do
    it "has a default balance of zero" do
      expect(oyster.balance).to eq 0
    end

    it "has a default state of not in journey" do
      expect(oyster.entry_station).to be_nil
    end

    it "has a an empty list of journeys" do
      expect(oyster.journey_history).to be_empty
    end
  end

  describe '#top_up' do
    context "when there is a balance on the card" do
      before do
        oyster.top_up(20)
      end

      it "adds the top up amount to the current balance" do
        expect(oyster.balance).to eq 20
      end

      it "raises an error if user tries to increase the balance over £90" do
        message = "£#{Oystercard::MAX_BALANCE} balance limit exceeded. Choose a smaller amount."
        expect{oyster.top_up(Oystercard::MAX_BALANCE)}.to raise_error message
      end
    end
  end

  describe '#touch_in' do

    context "when there is a balance on the card" do
      before do
        oyster.top_up(20)
      end

      it "allows a user to touch in" do
        expect{ oyster.touch_in(entry_station) }.not_to raise_error
      end

      it "records the entry station" do
        oyster.touch_in(entry_station)
        expect(oyster.entry_station).to eq entry_station
      end
    end

    context "when there is no balance on the card" do
      it "Should raise an error when the balance is below £#{Oystercard::MIN_FARE}" do
        message = "Can't touch in: you need at least £#{Oystercard::MIN_FARE} to travel"
        expect {oyster.touch_in(entry_station)}.to raise_error message
      end
    end
  end


  describe '#touch_out' do

    context "when there is a balance on the card and user has touched in" do
      before do
        oyster.top_up(20)
        oyster.touch_in(entry_station)
      end

      it "allows a user to touch out" do
        expect {oyster.touch_out(exit_station)}.not_to raise_error
      end

      it "resets entry station" do
        oyster.touch_out(exit_station)
        expect(oyster.entry_station).to be_nil
      end

      it "deducts the fare from the balance" do
        expect {oyster.touch_out(exit_station)}.to change{oyster.balance}.by(-(Oystercard::MIN_FARE))
      end

      it "records the exit station" do
        oyster.touch_out(exit_station)
        expect(oyster.exit_station).to eq exit_station
      end
    end
  end

  describe '#history' do
    context "when there is a balance on the card and journey is complete" do
      before do
        oyster.top_up(20)
        oyster.touch_in(entry_station)
        oyster.touch_out(exit_station)
      end
      it "after touching in and touching out, shows one journey" do
        expect(oyster.journey_history["Journey 1"]).to eq [entry_station, exit_station]
      end
    end
  end
end
