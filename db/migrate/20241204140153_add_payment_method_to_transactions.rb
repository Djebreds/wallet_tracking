class AddPaymentMethodToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :payment_method, :string
  end
end
