class AddCategoryToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :category, null: false, foreign_key: { to_table: :product_categories }
  end
end
