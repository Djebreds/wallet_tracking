# frozen_string_literal: true

module TopUpServices
  # Perform top up credit for user
  class AddCredit < ApplicationService
    def initialize(user, amount, payment_method)
      @user = user
      @amount = amount
      @payment_method = payment_method
    end

    def call
      raise ArgumentError, 'Amount must be greater than zero' unless valid_amount?

      user.update_credit(@amount)
      user.create_transaction(@user, @amount, :top_up, @payment_method)
    end

    private

    attr_reader :user, :amount

    def valid_amount?
      amount.present? && amount.positive?
    end
  end
end
