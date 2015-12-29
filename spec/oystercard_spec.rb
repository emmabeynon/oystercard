require 'oystercard'

describe Oystercard do
  subject(:oyster) { described_class.new }
  let(:forest_hill) { double :station, name: "Forest Hill", zone: 3 }
  let(:brockley) { double :station, name: "Brockley", zone: 2 }

  describe 'default' do
    it "has a default balance of zero" do
      expect(oyster.balance).to eq 0
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
        message = "£#{Oystercard::MAX_BALANCE} balance limit exceeded."\
        " Choose a smaller amount."
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
        expect{ oyster.touch_in(forest_hill) }.not_to raise_error
      end
    end

    context "when there is no balance on the card" do
      it "Should raise an error when the balance is below minumum fare" do
        stub_const("MIN_FARE", 1)
        message = "Can't touch in: you need at least £#{MIN_FARE} to travel"
        expect {oyster.touch_in(forest_hill)}.to raise_error message
      end
    end
  end


  describe '#touch_out' do
    context "when there is a balance on the card and user has touched in" do
      before do
        oyster.top_up(20)
        oyster.touch_in(forest_hill)
      end

      it "allows a user to touch out" do
        expect {oyster.touch_out(brockley)}.not_to raise_error
      end

      it "deducts the fare from the balance" do
        stub_const("MIN_FARE", 1)
        expect {oyster.touch_out(forest_hill)}.to change{oyster.balance}
          .by(-(MIN_FARE))
      end
    end

    context 'when the user has not touched in' do
      it 'allows a user to touch out' do
        expect {oyster.touch_out(brockley)}.not_to raise_error
      end
    end
  end
end
