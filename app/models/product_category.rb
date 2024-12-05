# frozen_string_literal: true

# Represent product category model
class ProductCategory < ApplicationRecord
  has_many :products, dependent: :restrict_with_exception
end
