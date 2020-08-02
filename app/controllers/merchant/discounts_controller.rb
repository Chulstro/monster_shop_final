class Merchant::DiscountsController < Merchant::BaseController

  def new
    @items = current_user.merchant.items
  end

  def create
    Discount.create(discount_params)
    redirect_to "/merchant"
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end

  private

  def discount_params
    params.permit(:item_id, :percentage, :number_needed, :merchant_id)
  end
end
