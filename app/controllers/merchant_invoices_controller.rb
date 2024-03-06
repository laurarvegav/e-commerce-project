class MerchantInvoicesController < ApplicationController
  def index
    @invoices = Merchant.find(params[:merchant_id]).invoices
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @invoice = Invoice.find(params[:id]) 
    @merchant = Merchant.find(params[:merchant_id])
    @invoice_brute_revenue = @invoice.invoice_items.sum { |i_i| i_i.brute_revenue}
    @invoice_net_revenue = @invoice.invoice_items.sum { |i_i| i_i.net_revenue}
  end
end