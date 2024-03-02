class MerchantInvoicesController < ApplicationController
  def index
    @invoices = Merchant.find(params[:merchant_id]).invoices
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @invoice = Invoice.find(params[:id]) 
    @merchant = Merchant.find(params[:merchant_id])
  end
end