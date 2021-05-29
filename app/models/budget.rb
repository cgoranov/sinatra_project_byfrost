
class Budget < ActiveRecord::Base
    belongs_to :user
    has_many :purchase_orders
    has_many :vendors, through: :purchase_orders

end