require 'oystercard'

describe Oystercard do
subject(:oyster) { described_class.new }


  it "Should have a default balance of zero" do
    expect(oyster.balance).to eq 0
  end

  it "should add the top up amount to the current balance" do
    oyster.top_up(30)
    expect(oyster.balance).to eq 30
  end

  it "Will raise error if user tries to increase the balance past £90" do
    allow(oyster).to receive(:balance).and_return(90)
    expect{oyster.top_up(10)}.to raise_error "The £#{Oystercard::MAX_BALANCE} maximum limit would be exceeded!"
  end

end
