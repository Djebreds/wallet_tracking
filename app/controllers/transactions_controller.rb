# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticated?

  def new; end

  def top_up; end
end
