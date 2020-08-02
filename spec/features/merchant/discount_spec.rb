require 'rails_helper'

RSpec.describe "When implementing a discount" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @user = User.create(name: "John", address: "145 Lowkey ln", city: "Philadelphia", state: "Pennsylvania", zip: 89769, role: 1, merchant: @megan)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
    @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    @discount_1 = @ogre.discounts.create(percentage: 20, number_needed: 50, merchant: @ogre.merchant)
  end

  it "has a link on the merchant dashboard to access a discount form" do
    visit '/merchant'

    click_on "Add Discount"
    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_field(:item_id)
    expect(page).to have_field(:percentage)
    expect(page).to have_field(:number_needed)
  end

  it "has a form that will create a discount for an item" do
    visit '/merchant/discounts'
    select "Ogre"

    fill_in :percentage, with: 20
    fill_in :number_needed, with: 10

    click_on "Create Discount"
    expect(current_path).to eq('/merchant')
    expect(page).to have_content("20%")
    expect(page).to have_content("Price when buying 10 or more")
  end

  it "has a show page for individual discounts" do
    visit "/merchant"

    click_on "#{@ogre.name}"

    expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}")
    expect(page).to have_content("Percentage off: 20")
    expect(page).to have_content("Bulk Needed: 50")
    expect(page).to have_content("#{@ogre.name}")
  end
end
