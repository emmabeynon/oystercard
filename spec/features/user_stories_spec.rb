require 'oystercard'


describe "User stories" do

  # In order to use public transport
  # As a customer
  # I want money on my card
  it "So that I can use public transport, I need money on the card" do
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
  it "So that I can protect my money, I want a max limit of £#{Oystercard::MAX_BALANCE}" do
    oyster = Oystercard.new
    expect {oyster.top_up(Oystercard::MAX_BALANCE+10)}.to raise_error "£#{Oystercard::MAX_BALANCE} balance limit exceeded. Choose a smaller amount."
  end

  # In order to get through the barriers.
  # As a customer
  # I need to touch in and out.
  it "So that I can enter the barriers, I need to touch in" do
    oyster = Oystercard.new
    oyster.top_up(20)
    expect{ oyster.touch_in("Canary Wharf") }.not_to raise_error
  end

  it "So that I can exit the barriers, I need to touch out" do
    oyster = Oystercard.new
    oyster.top_up(20)
    oyster.touch_in("Canary Wharf")
    expect{ oyster.touch_out("Oxford Circus") }.not_to raise_error
  end

  # In order to pay for my journey
  # As a customer
  # I need to have the minimum amount (£1) for a single journey.
  it "So that I can travel, my balance needs to be a minumum of £1 " do
    oyster = Oystercard.new
    expect {oyster.touch_in("Canary Wharf")}.to raise_error "Can't touch in: you need at least £#{Oystercard::MIN_FARE} to travel"
  end

  # In order to pay for my journey
  # As a customer
  # I need my fare deducted from my card
          # AND
  # In order to pay for my journey
  # As a customer
  # When my journey is complete, I need the correct amount deducted from my card

  it "So that I can pay for my journey, I needs the right amount deducted from my card" do
    oyster = Oystercard.new
    oyster.top_up(20)
    oyster.touch_in("Canary Wharf")
    expect {oyster.touch_out("Oxford Circus")}.to change{oyster.balance}.by(-(Oystercard::MIN_FARE))
  end

  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from

  it "So that I can pay for my journey, I need to know where I've travelled from" do
    oyster = Oystercard.new
    oyster.top_up(10)
    oyster.touch_in("Canary Wharf")
    expect(oyster.entry_station).to eq "Canary Wharf"
  end

  it "So that I can make another journey, I want the entry station to reset on exit" do
    oyster = Oystercard.new
    oyster.top_up(10)
    oyster.touch_in("Canary Wharf")
    oyster.touch_out("Oxford Circus")
    expect(oyster.entry_station).to be_nil
  end

  # In order to know where I have been
  # As a customer
  # I want to see to all my previous trips

  it "The card should have an empty list of journeys by default" do
    oyster = Oystercard.new
    expect(oyster.journey_history).to be_empty
  end

  it "So that I know where I've been, I want to see my previous trips" do
    oyster = Oystercard.new
    oyster.top_up(10)
    oyster.touch_in("Canary Wharf")
    oyster.touch_out("Oxford Circus")
    expect(oyster.journey_history["Journey 1"]).to eq ["Canary Wharf", "Oxford Circus"]
  end

end
