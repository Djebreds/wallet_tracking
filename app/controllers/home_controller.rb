# frozen_string_literal: true

# Handles home page
class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    products_query = Product.all

    if params[:search].present?
      products_query = products_query.where('name ILIKE :search', search: "%#{params[:search]}%")
    end

    products_query = products_query.where(category_id: params[:category]) if params[:category].present?

    @pagy, @products = pagy(products_query, page: params[:page], limit: 8)

    @categories = ProductCategory.all
  end
end
