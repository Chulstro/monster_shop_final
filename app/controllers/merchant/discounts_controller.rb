class Merchant::DiscountsController < Merchant::BaseController

  def new
    @items = current_user.merchant.items
  end

  def create
    discount = Discount.create(discount_params)
    if discount.save
      redirect_to "/merchant"
    else
      flash[:error] = "Must fill in all fields"
      redirect_to "/merchant/discounts"
    end
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end

  def edit
    @discount = Discount.find(params[:discount_id])
  end

  def update
    @discount = Discount.find(params[:discount_id])
    if @discount.update(edit_params)
      flash[:success] = "Discount successfully updated"
      redirect_to "/merchant/discounts/#{@discount.id}"
    else
      flash[:error] = "You must fill out all fields"
      redirect_to "/merchant/discounts/#{@discount.id}/edit"
    end
  end

  def destroy
    discount = Discount.find(params[:discount_id])
    discount.delete
    redirect_to "/merchant"
  end

  private

  def discount_params
    params.permit(:item_id, :percentage, :number_needed, :merchant_id)
  end

  def edit_params
    params.permit(:percentage, :number_needed)
  end
end
