require 'rails_helper'

RSpec.describe "When editing a discount" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @user = User.create(name: "John", address: "145 Lowkey ln", city: "Philadelphia", state: "Pennsylvania", zip: 89769, role: 1, merchant: @megan)
    @user_1 = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
    @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )
    @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 100 )
    @discount_1 = @ogre.discounts.create(percentage: 20, number_needed: 4, merchant: @ogre.merchant)
    @discount_2 = @ogre.discounts.create(percentage: 30, number_needed: 4, merchant: @ogre.merchant)
  end

  it "can be edited from its show page" do
    visit "/merchant/discounts/#{@discount_1.id}"

    click_on "Edit Discount"

    expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")

    expect(page).to have_field(:percentage)
    expect(page).to have_field(:number_needed)

    fill_in :percentage, with: 15
    fill_in :number_needed, with: ""

    click_on "Update Discount"
    expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
    expect(page).to have_content("You must fill out all fields")

    fill_in :percentage, with: 15
    fill_in :number_needed, with: 55

    click_on "Update Discount"
    expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}")
    expect(page).to have_content("Discount successfully updated")
  end
end
