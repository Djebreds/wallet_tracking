# frozen_string_literal: true

module TopUpServices
  # Perform top-up credit for user
  class AddCredit < ApplicationService
    def initialize(user, amount, payment_method)
      @user = user
      @amount = amount
      @payment_method = payment_method
    end

    def call
      ActiveRecord::Base.transaction do
        validate_amount!
        user.update_credit(amount)
        user.create_transaction(user, amount, :top_up, payment_method)
      end
    rescue StandardError => e
      Rails.logger.error e.message
      false
    end

    private

    attr_reader :user, :amount, :payment_method

    def validate_amount!
      raise ArgumentError, 'Amount must be greater than zero' unless valid_amount?
    end

    def valid_amount?
      amount.present? && amount.positive?
    end
  end
end
