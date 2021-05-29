class PurshaseOrderTable < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_orders do |t|
      t.integer :po_number
      t.integer :po_authorized_amount
      t.integer :vendor_id
      t.integer :budget_id
    end
  end
end
