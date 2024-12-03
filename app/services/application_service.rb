# frozen_string_literal: true

# Base class for service
class ApplicationService
  delegate :t, to: :I18n

  def self.call(*)
    instance = new(*args)
    instance.call
    instance
  end

  # return value should be ignored
  def call; end
end
