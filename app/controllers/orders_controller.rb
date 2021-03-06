class OrdersController < ApplicationController
  skip_before_filter :require_log_in, only: [:new, :create]

  def new
    @order = Order.new
    @order.build_credit_card
    Hash(session[:cart]).each do |pid, qty|
      @order.line_items.build(
          product_id: pid,
          quantity: qty)
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to root_path, notice: 'Your order has been placed'
    else
      flash.now[:alert] = @order.errors.full_messages.join(', ')
      logger.error "errors: #{@order.errors.full_messages.join(', ')}"
      render 'new'
    end
  end

  protected
  def order_params
    params.require(:order).permit(
        credit_card_attributes: [:cardholder_name, :card_number, :expiration_month, :expiration_year],
        line_items_attributes: [:product_id, :quantity])
  end
end