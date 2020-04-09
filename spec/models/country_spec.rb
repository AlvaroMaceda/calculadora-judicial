require 'rails_helper'

RSpec.describe Country, type: :model do

  it "has a valid factory" do
    country = create(:country)
    expect(country).to be_valid
  end

  it "is invalid without a name" do
    country = build(:country, name: nil)
    expect(country).not_to be_valid
  end

  it "has autonomous communities" do
  end

end
