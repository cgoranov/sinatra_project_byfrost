
class Budget < ActiveRecord::Base
    belongs_to :user
    has_many :purchase_orders, dependent: :destroy
    has_many :vendors, through: :purchase_orders
    validates :name, :target, presence: true
    validates :target, numericality: { only_integer: true }
    # validates :name, uniqueness: true
end