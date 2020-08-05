require 'rails_helper'

RSpec.describe "When implementing a discount" do
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
    within "#discount-#{@discount_1.id}" do
      click_on "#{@ogre.name}"
    end

    expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}")
    expect(page).to have_content("Percentage off: 20")
    expect(page).to have_content("Bulk Needed: 4")
    expect(page).to have_content("#{@ogre.name}")
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

  it "can be deleted from it's show page" do
    visit "/merchant/discounts/#{@discount_1.id}"

    click_on "Delete Discount"

    expect(current_path).to eq("/merchant")
  end

  it "applies to the cart once the right number of items are queued up" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

    visit "/items"
    click_on "Ogre"
    click_on "Add to Cart"
    visit "/items"
    click_on "Hippo"
    click_on "Add to Cart"
    click_on "Cart: 2"

    within "#item-#{@ogre.id}" do
      click_on "More of This!"
      click_on "More of This!"
      click_on "More of This!"
      click_on "More of This!"

      expect(page).to have_content("Quantity: 5")
      expect(page).to have_content("Subtotal: $70.00")
    end
  end

  it "adds the correct info to orders in creation" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

    visit "/items"
    click_on "Ogre"
    click_on "Add to Cart"
    visit "/items"
    click_on "Hippo"
    click_on "Add to Cart"
    click_on "Cart: 2"

    within "#item-#{@ogre.id}" do
      click_on "More of This!"
      click_on "More of This!"
      click_on "More of This!"
      click_on "More of This!"
    end
    click_on "Check Out"
    order = Order.first

    expect(current_path).to eq("/profile/orders")
    click_on "#{order.id}"

    expect(current_path).to eq("/profile/orders/#{order.id}")
    expect(page).to have_content("Discount Applied: 30%")

  end

  it "can't create a discount with wrong params" do
    visit '/merchant/discounts'
    select "Ogre"

    fill_in :percentage, with: ""
    fill_in :number_needed, with: ""

    click_on "Create Discount"
    expect(current_path).to eq('/merchant/discounts')
    expect(page).to have_content("Must fill in all fields")

    fill_in :percentage, with: 101
    fill_in :number_needed, with: 1
    click_on "Create Discount"
    expect(current_path).to eq('/merchant/discounts')
    expect(page).to have_content("Must fill in all fields")
  end
end
