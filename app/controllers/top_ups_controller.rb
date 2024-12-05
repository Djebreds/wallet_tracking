# frozen_string_literal: true

# Handles user top up credits
class TopUpsController < ApplicationController
  before_action :authenticated?

  def create
    amount = top_up_params[:amount].to_d
    payment_method = top_up_params[:payment_method]

    validate_amount!(amount)
    validate_payment_method!(payment_method)

    add_credit = TopUpServices::AddCredit.call(current_user, amount, payment_method)

    if add_credit
      redirect_to root_path, notice: t('top_up.top_up_successfully')
    else
      redirect_to top_up_path, alert: t('top_up.top_up_failed')
    end
  end

  private

  def validate_amount!(amount)
    redirect_to root_path, alert: t('top_up.amount_must_be_positive') if invalid_amount?(amount)
  end

  def validate_payment_method!(payment_method)
    redirect_to root_path, alert: t('top_up.invalid_payment_method') unless invalid_payment_method?(payment_method)
  end

  def top_up_params
    params.permit(:amount, :payment_method)
  end

  def invalid_amount?(amount)
    !amount.is_a?(Numeric) || amount <= 0
  end

  def invalid_payment_method?(payment_method)
    Transaction.payment_methods.key?(payment_method)
  end
end
