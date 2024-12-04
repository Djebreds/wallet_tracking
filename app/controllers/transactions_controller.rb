# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticated?

  def index
    @transaction_types = Transaction.transaction_types.keys.map do |key|
      Struct.new(:id, :name).new(
        key,
        key.humanize,
      )
    end

    transactions_query = current_user.transactions
    transactions_query = current_user.transactions.where(transaction_type: params[:type]) if params[:type].present?

    @pagy, @transactions = pagy(transactions_query, page: params[:page], limit: 8)
  end
end
