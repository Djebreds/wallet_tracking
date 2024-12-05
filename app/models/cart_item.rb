# frozen_string_literal: true

# Represent cart item model
class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
end
