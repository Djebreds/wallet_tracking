# frozen_string_literal: true

# Handles home page
class HomeController < ApplicationController
  allow_unauthenticated_access
  before_action :set_cart, if: :authenticated?

  def index
    products_query = Product.includes(:category)
    products_query = apply_filters(products_query)

    @pagy, @products = pagy(products_query, page: params[:page], limit: 8)
    @categories = ProductCategory.all
  end

  private

  def apply_filters(products)
    products = product_search_query(products)
    filter_by_category(products)
  end

  def product_search_query(products)
    return products if params[:search].blank?

    products.where('name ILIKE :search', search: "%#{params[:search]}%")
  end

  def filter_by_category(products)
    return products if params[:category].blank?

    products.where(category_id: params[:category])
  end
end
