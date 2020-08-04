# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
@brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
@ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
@giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
@nessie = @brian.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
@hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Loch Monster!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
@gator = @brian.items.create!(name: 'Gator', description: "I'm a Loch Monster!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
@review_1 = @ogre.reviews.create(title: 'Great!', description: 'This Ogre is Great!', rating: 5)
@review_2 = @ogre.reviews.create(title: 'Meh.', description: 'This Ogre is Mediocre', rating: 3)
@review_3 = @ogre.reviews.create(title: 'EW', description: 'This Ogre is Ew', rating: 1)
@review_4 = @ogre.reviews.create(title: 'So So', description: 'This Ogre is So so', rating: 2)
@review_5 = @ogre.reviews.create(title: 'Okay', description: 'This Ogre is Okay', rating: 4)
@discount_1 = @ogre.discounts.create(percentage: 20, number_needed: 5, merchant: @ogre.merchant)
@discount_2 = @ogre.discounts.create(percentage: 30, number_needed: 6, merchant: @ogre.merchant)
@user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'user@example.com', password: 'securepassword')
@m_user = @megan.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'merchant@example.com', password: 'securepassword')
@order_1 = @user.orders.create!
@order_2 = @user.orders.create!
@order_3 = @user.orders.create!
@order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
@order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
@order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 5)
@order_3.order_items.create!(item: @nessie, price: @nessie.price, quantity: 7)
@order_3.order_items.create!(item: @gator, price: @gator.price, quantity: 1)
