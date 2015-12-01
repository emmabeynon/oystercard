require 'oystercard'

describe Oystercard do
subject(:oyster) { described_class.new }
let(:station) {double :station}


  describe 'default' do
    it "Should have a default balance of zero" do
      expect(oyster.balance).to eq 0
    end

      it "Should have a default state of not in journey" do
        expect(oyster).not_to be_in_journey
      end
  end

  describe '#top_up' do

    context "Has money on card" do
      before do
        oyster.top_up(20)
      end

      it "should add the top up amount to the current balance" do
        expect(oyster.balance).to eq 20
      end

      it "Will raise error if user tries to increase the balance past £90" do
        expect{oyster.top_up(Oystercard::MAX_BALANCE)}.to raise_error "The £#{Oystercard::MAX_BALANCE} maximum limit would be exceeded!"
      end
    end
  end

  describe '#touch_in' do

    context "Has money on card" do
      before do
        oyster.top_up(20)
      end
      it "Should allow me to touch in" do
        oyster.touch_in(station)
        expect(oyster).to be_in_journey
      end

      it "Remembers which station you entered in from" do
        oyster.touch_in(station)
        expect(oyster.entry_station).to eq station
      end
     end

     context "Starts with 0 balance" do
       it "Should raise an error when the balance is below £#{Oystercard::MIN_FARE}" do
         message = "Insufficient funds: you need at least £#{Oystercard::MIN_FARE} to travel"
         expect {oyster.touch_in(station)}.to raise_error message
       end
     end
   end


  describe '#touch_out' do

    context "Has money on card" do
      before do
        oyster.top_up(20)
        oyster.touch_in(station)
      end
      it "Should let me touch out" do
        oyster.touch_out(station)
        expect(oyster).not_to be_in_journey
      end

      it "Resets entry station on touch out" do
        oyster.touch_out(station)
        expect(oyster.entry_station).to be_nil
      end

      it "Charges the user the correct amount" do
        expect {oyster.touch_out(station)}.to change{oyster.balance}.by(-(Oystercard::MIN_FARE))
      end
      it "Records the exit station" do
        oyster.touch_out(station)
        expect(oyster.exit_station).to eq station
      end
    end
  end

  describe '#history' do
    context "Has money on card" do
      before do
        oyster.top_up(20)
      end
    it "Should allow user to view history" do
      oyster.touch_in(station)
      oyster.touch_out(station)
      expect(oyster.journey_history).to return({"Journey 1" => [station, station]})
      end
    end
  end
end
