# frozen_string_literal: true

# Represents a user in the application.
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :transactions, dependent: :restrict_with_exception

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :credit, numericality: { greater_than_or_equal_to: 0 }

  def update_credit(amount)
    update!(credit: credit + amount)
  end

  def create_transaction(user, amount, transaction_type, payment_method)
    transactions.create!(
      user_id: user.id,
      amount:,
      transaction_type:,
      payment_method: payment_method
    )
  end
end
