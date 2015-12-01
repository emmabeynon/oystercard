require 'oystercard'


describe "User stories" do

  # In order to use public transport
  # As a customer
  # I want money on my card
  it "So that I can use public transport, I need money on card" do
    oyster = Oystercard.new
    expect {oyster.balance}.not_to raise_error
  end

  # In order to keep using public transport
  # As a customer
  # I want to add money to my card
  it "So that I can keep using public transport, I need to be able to top up" do
    oyster = Oystercard.new
    expect {oyster.top_up(10)}.not_to raise_error
  end

  # In order to protect my money from theft or loss
  # As a customer
  # I want a maximum limit (of £90) on my card
  it "So that I don't risk too much money, I want a max limit of £#{Oystercard::MAX_BALANCE}" do
    oyster = Oystercard.new
    expect {oyster.top_up(Oystercard::MAX_BALANCE+10)}.to raise_error "The £#{Oystercard::MAX_BALANCE} maximum limit would be exceeded!"
  end

  # In order to get through the barriers.
  # As a customer
  # I need to touch in and out.
  it "So that I can get in through the barriers, I need to touch in" do
    oyster = Oystercard.new
    oyster.top_up(20)
    oyster.touch_in("Canary Wharf")
    expect(oyster.in_journey?).to eq true
  end

  it "So that I can get out the barriers, I need to touch out" do
    oyster = Oystercard.new
    oyster.top_up(20)
    oyster.touch_in("Canary Wharf")
    oyster.touch_out
    expect(oyster.in_journey?).to eq false
  end

  # In order to pay for my journey
  # As a customer
  # I need to have the minimum amount (£1) for a single journey.
  it "So that I can travel my balance needs to have a minumum of £1 " do
    oyster = Oystercard.new
    expect {oyster.touch_in("Canary Wharf")}.to raise_error "Insufficient funds: you need at least £#{Oystercard::MIN_FARE} to travel"
  end

  # In order to pay for my journey
  # As a customer
  # I need my fare deducted from my card
          # AND
  # In order to pay for my journey
  # As a customer
  # When my journey is complete, I need the correct amount deducted from my card

  it "So that I get charge the right amount, I want to be charged the right amount" do
    oyster = Oystercard.new
    oyster.top_up(20)
    oyster.touch_in("Canary Wharf")
    expect {oyster.touch_out}.to change{oyster.balance}.by(-(Oystercard::MIN_FARE))
  end

  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from

  it "So that I can pay, I need to know where I've travelled from" do
    oyster = Oystercard.new
    oyster.top_up(10)
    oyster.touch_in("Canary Wharf")
    expect(oyster.entry_station).to eq "Canary Wharf"
  end

  it "So that I can make another journey, I want the entry station to reset on exit" do
    oyster = Oystercard.new
    oyster.top_up(10)
    oyster.touch_in("Canary Wharf")
    oyster.touch_out
    expect(oyster.entry_station).to be_nil
  end



end
