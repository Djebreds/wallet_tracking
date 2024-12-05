# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def set_cart
    return unless current_user

    @cart = current_user.cart || current_user.create_cart
    @cart_items = @cart.cart_items

    @total_price = @cart_items.sum { |item| item.product.price * item.quantity }
  end
end
