# frozen_string_literal: true

# Handles transactions
class TransactionsController < ApplicationController
  before_action :authenticated?
  before_action :set_cart, if: :authenticated?

  def index
    @transaction_types = humanize_transaction_types
    @statuses = humanize_statuses

    transactions_query = current_user.transactions
    transactions_query = filter_by_type(transactions_query)
    transactions_query = filter_by_status(transactions_query)
    transactions_query = filter_by_date_range(transactions_query)

    @pagy, @transactions = pagy(transactions_query, page: params[:page], limit: 8)
  end

  def purchase
    total = purchase_params[:total].to_d
    payment_method = purchase_params[:payment_method]

    validate_user_credit!(total)

    purchase = TransactionServices::PurchaseService.call(current_user, total, payment_method, @cart_items)

    if purchase
      redirect_to root_path, notice: t('transaction.purchase_complete')
    else
      redirect_to root_path, alert: t('transaction.purchase_failed')
    end
  end

  private

  def validate_user_credit!(total)
    redirect_to root_path, alert: t('transaction.insufficient_credit') if current_user.credit < total
  end

  def purchase_params
    params.permit(:payment_method, :total)
  end

  def filter_by_type(transactions)
    return transactions if params[:type].blank?

    transactions.where(transaction_type: params[:type])
  end

  def filter_by_status(transactions)
    return transactions if params[:status].blank?

    transactions.where(status: params[:status])
  end

  def filter_by_date_range(transactions)
    return transactions unless params[:start_date].present? || params[:end_date].present?

    start_date = params[:start_date].presence
    end_date = params[:end_date].presence || Time.zone.today.to_s
    transactions.where('created_at BETWEEN ? AND ?', start_date, end_date)
  end
end
