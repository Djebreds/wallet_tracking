# frozen_string_literal: true

# Handles user top up credits
class TopUpsController < ApplicationController
  before_action :authenticated?

  def create
    amount = top_up_params[:amount].to_d
    Rails.logger.info "Amount received: #{amount.inspect}"
    if invalid_amount?(amount)
      flash[:alert] = 'Amount must be a valid positive number.'
      redirect_to root_path and return
    end

    TopUpServices::AddCredit.call(current_user, amount)

    redirect_to root_path, notice: 'Your credit has been successfully updated!'
  end

  private

  def top_up_params
    params.permit(:amount)
  end

  def invalid_amount?(amount)
    !amount.is_a?(Numeric) || amount <= 0
  end
end
