class VendorsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :vendors do |t|
      t.string :name
    end
  end
end
