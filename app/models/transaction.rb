# frozen_string_literal: true

# Represents a transaction in the application.
class Transaction < ApplicationRecord
  belongs_to :user
end
