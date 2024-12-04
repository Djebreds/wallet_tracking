# frozen_string_literal: true

# product jobs module
module ProductJobs
  require 'faraday'

  FAKE_STORE_API = 'https://fakestoreapi.com'

  # Insert product data from Fake store API
  class FetchProductJob
    include Sidekiq::Job

    def perform(*_args)
      products = fetch_products
      return if products.nil?

      save_or_update_products_and_categories(products)
    rescue StandardError => e
      Rails.logger.error("Error in FetchProductsJob: #{e.message}")
    end

    private

    # @return [Array<Hash>, nil]
    def fetch_products
      response = Faraday.get("#{FAKE_STORE_API}/products")

      if response.success?
        JSON.parse(response.body, symbolize_names: true)
      else
        Rails.logger.error("Failed to fetch products: #{response.status}")
        nil
      end
    end

    # @param [Array<Hash>] api_products
    def save_or_update_products_and_categories(api_products)
      ActiveRecord::Base.transaction do
        categories = extract_categories(api_products)
        save_categories(categories)

        mapped_products = mapping_products(api_products)
        Product.import mapped_products, on_duplicate_key_update: {
          conflict_target: [:id],
          columns: %i[name price description image_url category_id updated_at]
        }
      end
    end

    # @param [Array<Hash>] api_products
    # @return [Array<String>]
    def extract_categories(api_products)
      api_products.pluck(:category).uniq
    end

    # @param [Array<string>] categories
    def save_categories(categories)
      existing_categories = ProductCategory.pluck(:name)
      new_categories = categories - existing_categories

      new_category_records = new_categories.map do |name|
        ProductCategory.new(name: name, created_at: Time.current, updated_at: Time.current)
      end

      ProductCategory.import(new_category_records, validate: true)
    end

    # @param [Array<Hash>] api_products
    # @return [Array<Hash>]
    # rubocop:disable Metrics/MethodLength
    def mapping_products(api_products)
      categories = ProductCategory.pluck(:name, :id).to_h

      api_products.map do |product|
        {
          id: product[:id],
          name: product[:title],
          price: product[:price],
          description: product[:description],
          image_url: product[:image],
          category_id: categories[product[:category]],
          created_at: Time.current,
          updated_at: Time.current
        }
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
