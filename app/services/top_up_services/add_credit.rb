# frozen_string_literal: true

module TopUpServices

  # Perform top up credit for user
  class AddCredit < ApplicationService
    def initialize(user, amount)
      @user = user
      @amount = amount
    end

    def call
      raise ArgumentError, 'Amount must be greater than zero' unless valid_amount?

      user.update_credit(@amount)
      user.create_transaction(@user, @amount, :top_up)
    end

    private

    attr_reader :user, :amount

    def valid_amount?
      amount.present? && amount.positive?
    end
  end
end
