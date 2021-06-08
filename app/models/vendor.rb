
class Vendor < ActiveRecord::Base
    has_many :purchase_orders
    validates :name, presence: true
end