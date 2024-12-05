# frozen_string_literal: true

# Handles cart
class CartsController < ApplicationController
  before_action :authenticated?
  before_action :set_cart

  def add_item
    product = Product.find(params[:product_id])
    item = find_or_initialize_item(product)

    if save_item(item)
      redirect_to root_path, notice: t('cart.added_to_cart', product: product.name)
    else
      redirect_to root_path, alert: t('cart.failed_add_to_cart')
    end
  end

  def remove_item
    item = @cart.cart_items.find(params[:item_id])
    if item.destroy
      redirect_to cart_path, notice: t('cart.item_removed')
    else
      redirect_to cart_path, alert: t('cart.failed_to_remove_item')
    end
  end

  private

  def find_or_initialize_item(product)
    item = @cart.cart_items.find_by(product: product)
    if item
      item.quantity += 1
    else
      item = @cart.cart_items.new(product: product, quantity: 1)
    end
    item
  end

  def save_item(item)
    item.save
  end
end
