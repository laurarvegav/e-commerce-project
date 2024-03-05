class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    parsed_holiday_data = HolidayService.new.upcoming_holidays

    @holidays = parsed_holiday_data.map { |holiday| Holiday.new(holiday) }
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    if params["bulk_discount"].present?
      create_holiday_discount(@merchant)
    else 
      bulk_discount = BulkDiscount.new(discount_merchant_params)
      if bulk_discount.save
        redirect_to merchant_bulk_discounts_path(@merchant)
      else 
        redirect_to new_merchant_bulk_discount_path(@merchant.id)
        flash[:alert] =  "Error: #{error_message(bulk_discount.errors)}"
      end
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    update_discount(bulk_discount,merchant)
  end

  def update_discount(bulk_discount,merchant)
    if bulk_discount.update(discount_merchant_params)
      bulk_discount.update(discount_merchant_params)
      redirect_to merchant_bulk_discount_path(merchant, bulk_discount)
      flash[:success] = "The information has been successfully updated for the discount"
    else
      redirect_to edit_merchant_bulk_discount_path(merchant, bulk_discount)
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  
  private
  def create_holiday_discount(merchant)
    merchant = Merchant.find(params[:merchant_id])
    @dct_name = holiday_discount_params
    @bulk_discount = merchant.bulk_discounts.new(quantity_treshold: 2, percentage_discount: 30)
  
    if @bulk_discount.save
      render 'new'
    end
  end

  def discount_merchant_params
    params.permit(:percentage_discount, :quantity_treshold, :merchant_id)
  end

  def holiday_discount_params
    params.require(:bulk_discount).permit(:holiday_name, :merchant_id)
  end
end