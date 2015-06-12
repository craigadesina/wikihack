class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true
      t.string :charge

      t.timestamps null: false
    end
    add_foreign_key :transactions, :users
  end
end
