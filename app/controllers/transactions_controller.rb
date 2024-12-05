# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticated?

  def index
    @transaction_types = humanize_transaction_types
    @statuses = humanize_statuses
    transactions_query = current_user.transactions
    transactions_query = filter_by_type(transactions_query)
    transactions_query = filter_by_status(transactions_query)
    transactions_query = filter_by_date_range(transactions_query)

    @pagy, @transactions = pagy(transactions_query, page: params[:page], limit: 8)
  end

  private

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

  def humanize_transaction_types
    Transaction.transaction_types.keys.map do |key|
      Struct.new(:id, :name).new(key, key.humanize)
    end
  end

  def humanize_statuses
    Transaction.statuses.keys.map do |key|
      Struct.new(:id, :name).new(key, key.humanize)
    end
  end
end
