class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :transaction_type
      t.decimal :amount, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
