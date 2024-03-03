class MerchantItemsController < ApplicationController
  def index
    @items = Merchant.find(params[:merchant_id]).items
  end

  def show 
    @item = Item.find(params[:id])
  end

  def edit
    @merch = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    if params[:status] == "0" || params[:status] == "1"
      item.update(status: item_params[:status].to_i)
      redirect_to merchant_invoice_path(params[:merchant_id], params[:invoice_id])
    elsif params[:status]
      item.update(item_params)
      redirect_to merchant_items_path(params[:merchant_id])
    else 
      item.update(item_params)
      flash[:alert] = "Update successful"
      redirect_to merchant_item_path(params[:merchant_id], params[:id])
    end
  end

  def new
    @merch = Merchant.find(params[:merchant_id])
  end

  def create
    item = Item.new(item_params)
    
    if item.save
      redirect_to merchant_items_path(params[:merchant_id])
    else 
      redirect_to new_merchant_item_path(params[:merchant_id])
      flash[:alert] =  "Error: #{error_message(item.errors)}"
    end
  end

  private 
  def item_params
    params.permit(:name, :description, :unit_price, :status, :merchant_id)
  end
end