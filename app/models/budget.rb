
class Budget < ActiveRecord::Base
    belongs_to :user
    has_many :purchase_orders

end