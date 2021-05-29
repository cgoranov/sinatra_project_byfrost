class BudgetTable < ActiveRecord::Migration[6.1]
  def change
    create_table :budgets do |t|
      t.string :name
      t.integer :target
      t.integer :user_id
    end
  end
end
