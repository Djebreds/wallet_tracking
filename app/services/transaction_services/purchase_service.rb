# frozen_string_literal: true

module TransactionServices
  # Perform purchase for user
  class PurchaseService < ApplicationService
    def initialize(user, total, payment_method, items)
      @user = user
      @total = total
      @payment_method = payment_method
      @items = items
    end

    def call
      ActiveRecord::Base.transaction do
        validate_credit!
        process_payment
        record_transaction
        clear_cart
      end
    rescue StandardError => e
      Rails.logger.error e.message
      false
    end

    private

    attr_reader :user, :total, :payment_method, :items

    def validate_credit!
      raise 'Insufficient credit' if payment_method == 'wallet' && user.credit < total
    end

    def process_payment
      user.update_credit(-total) if payment_method == 'wallet'
    end

    def record_transaction
      user.create_transaction(user, total, :purchase, payment_method)
    end

    def clear_cart
      items.destroy_all
    end
  end
end
