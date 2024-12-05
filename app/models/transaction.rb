# frozen_string_literal: true

# Represents a transaction in the application.
class Transaction < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  enum :transaction_type, {
    top_up: 'top-up',
    purchase: 'purchase'
  }

  enum :payment_method, {
    in_app_top_up: 'in-app-top-up',
    wallet: 'wallet'
  }

  enum :status, {
    confirmed: 'confirmed',
    failed: 'failed',
    canceled: 'canceled'
  }
end
