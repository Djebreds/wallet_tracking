# frozen_string_literal: true

module Fetch
  class ProductsJob
    include Sidekiq::Job

    def perform(*args)
      # Do something
    end
  end
end
