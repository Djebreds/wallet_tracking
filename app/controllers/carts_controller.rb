# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticated?
  before_action :set_cart

  def add_item
    product = Product.find(params[:product_id])

    item = @cart.cart_items.find_by(product: product)

    if item
      item.increment!(:quantity)
    else
      item = @cart.cart_items.create(product: product, quantity: 1)
    end

    if item.persisted?
      redirect_to root_path, notice: "#{product.name} added to cart."
    else
      redirect_to root_path, alert: 'Unable to add product to cart.'
    end
  end

  def remove_item
    item = @cart.cart_items.find(params[:item_id])
    item.destroy
    redirect_to cart_path, notice: 'Item removed from cart.'
  end
end
