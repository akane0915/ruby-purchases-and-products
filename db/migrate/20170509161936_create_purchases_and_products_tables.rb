class CreatePurchasesAndProductsTables < ActiveRecord::Migration[5.1]
  def change
    create_table(:purchases) do |t|
      t.string :customer_name
    end

    create_table(:products) do |t|
      t.string :name
      t.string :description
      t.belongs_to(:purchase, index:true)
      t.decimal :price, precision: 10, scale: 2
      t.timestamps
    end
  end
end
