require 'oystercard'
require 'station'
require 'journey'
require 'journey_log'

describe "User stories" do
  subject(:oyster) { Oystercard.new }
  subject(:station) { Station.new("Whitechapel", 2) }
  subject(:journey) { Journey.new }
  subject(:journey_log) { JourneyLog.new(Journey.new) }
  subject(:brockley) { Station.new("Brockley", 2)}
  subject(:forest_hill) { Station.new("Forest Hill", 3)}

  describe 'JourneyLog' do
    # In order to know where I have been
    # As a customer
    # I want to see to all my previous trips
    it "has an empty list of journeys by default" do
      expect(journey_log.journey_history).to be_empty
    end

    it "shows user a list of previous journeys" do
      oyster.top_up(10)
      oyster.touch_in(brockley)
      oyster.touch_out(forest_hill)
      expect(oyster.journey_log.journey_history).not_to be_empty
    end
  end

  describe 'Journey' do
    # In order to pay for my journey
    # As a customer
    # I need to know where I've travelled from
    it "shows user where they have travelled from" do
      oyster.top_up(10)
      oyster.touch_in("Canary Wharf")
      expect(oyster.journey_log.journey.entry_station).to eq "Canary Wharf"
    end

    # In order to be charged the correct amount
    # As a customer
    # I need to have the correct fare calculated
    it 'calculates the correct fare for the number of zones travelled' do
      oyster.top_up(10)
      oyster.touch_in(forest_hill)
      oyster.touch_out(brockley)
      expect(oyster.balance).to eq 8
    end
  end

  describe 'Oystercard' do
    # In order to use public transport
    # As a customer
    # I want money on my card
    it "has a balance" do
      expect {oyster.balance}.not_to raise_error
    end

    # In order to keep using public transport
    # As a customer
    # I want to add money to my card
    it "allows user to top up their balance" do
      expect {oyster.top_up(10)}.not_to raise_error
    end

    # In order to protect my money from theft or loss
    # As a customer
    # I want a maximum limit (of £90) on my card
    it "has a max balance of £#{Oystercard::MAX_BALANCE}" do
      message = "£#{Oystercard::MAX_BALANCE} balance limit exceeded. Choose a smaller amount."
      expect {oyster.top_up(Oystercard::MAX_BALANCE+10)}.to raise_error message
    end

    # In order to get through the barriers.
    # As a customer
    # I need to touch in and out.
    it "allows user to touch in" do
      oyster.top_up(20)
      expect{ oyster.touch_in("Canary Wharf") }.not_to raise_error
    end

    it "allows user to touch out" do
      oyster.top_up(20)
      oyster.touch_in(forest_hill)
      expect{ oyster.touch_out(brockley) }.not_to raise_error
    end

    # In order to pay for my journey
    # As a customer
    # I need to have the minimum amount (£1) for a single journey.
    it "raises an error if the user's balance isn't a minumum of £1 " do
      message = "Can't touch in: you need at least £#{Journey::MIN_FARE} to travel"
      expect {oyster.touch_in("Canary Wharf")}.to raise_error message
    end

    # In order to pay for my journey
    # As a customer
    # I need my fare deducted from my card
            # AND
    # In order to pay for my journey
    # As a customer
    # When my journey is complete, I need the correct amount deducted from my card
    it "deducts the minimum fare if the user completes their journey" do
      oyster.top_up(20)
      oyster.touch_in(brockley)
      expect{oyster.touch_out(brockley)}.to change{oyster.balance}.by(-Journey::MIN_FARE)
    end

    it 'deducts a penalty fare if the user does not touch out' do
      oyster.top_up(20)
      oyster.touch_in("Canary Wharf")
      oyster.incomplete_journey
      expect(oyster.balance).to eq(20-Journey::PENALTY_FARE)
    end

    it 'deducts a penalty fare if the user does not touch out' do
      oyster.top_up(20)
      oyster.touch_out("Canary Wharf")
      expect(oyster.balance).to eq(20-Journey::PENALTY_FARE)
    end

  end

  describe 'Station' do
    # In order to know how far I have travelled
    # As a customer
    # I want to know what zone a station is in

    it "tells user what zone a station is in" do
      expect(station.name).to eq "Whitechapel"
    end

    it "tells user what the station's name is" do
      expect(station.zone).to eq 2
    end
  end

end
