# frozen_string_literal: true

# Handles home page
class HomeController < ApplicationController
  allow_unauthenticated_access
  before_action :set_cart, if: :authenticated?

  def index
    products_query = Product.includes(:category)
    product_search_query(products_query, params[:search])
    products_query = products_query.where(category_id: params[:category]) if params[:category].present?

    @pagy, @products = pagy(products_query, page: params[:page], limit: 8)
    @categories = ProductCategory.all
  end

  private

  def product_search_query(products_query, search)
    products_query.where('name ILIKE :search', search: "%#{search}%") if search.present?
  end
end
