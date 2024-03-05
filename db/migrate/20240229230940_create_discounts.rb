class CreateDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :discounts do |t|
      t.integer :percent_discount
      t.integer :quantity_threshold
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
