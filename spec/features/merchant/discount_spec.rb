require 'rails_helper'

RSpec.describe "When implementing a discount" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @user = User.create(name: "John", address: "145 Lowkey ln", city: "Philadelphia", state: "Pennsylvania", zip: 89769, role: 1, merchant: @megan)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "has a link on the merchant dashboard to access a discount form" do
    visit '/merchant'

    click_on "Create Discount"
    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_field(:item)
    expect(page).to have_field(:percentage)
    expect(page).to have_field(:number_needed)
  end

  it "has a form that will "
end
