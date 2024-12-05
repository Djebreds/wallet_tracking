# frozen_string_literal: true

# Represent product model
class Product < ApplicationRecord
  belongs_to :category, class_name: 'ProductCategory'
end
