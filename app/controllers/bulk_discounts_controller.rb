class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.new(discount_merchant_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(merchant)
    else 
      redirect_to new_merchant_bulk_discount_path(merchant.id)
      flash[:alert] =  "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  private
  def discount_merchant_params
    params.permit(:percentage_discount, :quantity_treshold, :merchant_id)
  end
end