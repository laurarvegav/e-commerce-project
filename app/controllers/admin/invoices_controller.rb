class Admin::InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @revenue = @invoice.total_revenue_dollars
    @net_revenue = @invoice.total_revenue_dollars * ( 1 - @invoice.eligible_discount)
  end

  def update
    invoice = Invoice.find(params[:id])

    invoice.update(status: strong_params[:status].to_i)

    redirect_to admin_invoice_path(invoice)
  end

  private
  def strong_params
    params.permit(:id, :status)
  end
end