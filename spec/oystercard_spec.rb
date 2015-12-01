require 'oystercard'

describe Oystercard do
subject(:oyster) { described_class.new }
let(:station) {station = "Canary Wharf"}


  it "Should have a default balance of zero" do
    expect(oyster.balance).to eq 0
  end

  it "should add the top up amount to the current balance" do
    oyster.top_up(30)
    expect(oyster.balance).to eq 30
  end

  it "Will raise error if user tries to increase the balance past £90" do
    expect{oyster.top_up(Oystercard::MAX_BALANCE+10)}.to raise_error "The £#{Oystercard::MAX_BALANCE} maximum limit would be exceeded!"
  end

  it "Should allow me to touch in" do
    oyster.top_up(20)
    oyster.touch_in(station)
    expect(oyster).to be_in_journey
  end

  it "Should let me touch out" do
    oyster.top_up(20)
    oyster.touch_in(station)
    oyster.touch_out
    expect(oyster).not_to be_in_journey
  end

  it "Should have a default state of not in journey" do
    expect(oyster).not_to be_in_journey
  end

  it "Should raise an error when the balance is below £#{Oystercard::MIN_FARE}" do
    message = "Insufficient funds: you need at least £#{Oystercard::MIN_FARE} to travel"
    expect {oyster.touch_in(station)}.to raise_error message
  end
  it "Charges the user the correct amount" do
    oyster.top_up(20)
    oyster.touch_in(station)
    expect {oyster.touch_out}.to change{oyster.balance}.by(-(Oystercard::MIN_FARE))
  end

  it "Remembers which station you entered in from" do
    oyster.top_up(10)
    oyster.touch_in(station)
    expect(oyster.entry_station).to eq station
  end

  it "Resets entry station on touch out" do
    oyster.top_up(10)
    oyster.touch_in(station)
    oyster.touch_out
    expect(oyster.entry_station).to be_nil
  end

end
