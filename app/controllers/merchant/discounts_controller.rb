class Merchant::DiscountsController < Merchant::BaseController

  def new
    @items = current_user.merchant.items
  end
end
