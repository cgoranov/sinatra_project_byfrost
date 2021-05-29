
class User < ActiveRecord::Base
    has_many :budgets
    has_many :purchase_orders, through: :budgets
end