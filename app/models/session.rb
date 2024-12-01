# frozen_string_literal: true

# Represents a session in the application.
class Session < ApplicationRecord
  belongs_to :user
end
