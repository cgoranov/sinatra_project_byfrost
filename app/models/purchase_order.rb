

class PurchaseOrder < ActiveRecord::Base
    belongs_to :vendor
    belongs_to :budget
    validates :po_number, :po_authorized_amount, :vendor_id, :budget_id, presence: true
    validates :po_number, :po_authorized_amount, numericality: { only_integer: true }
    validates :po_number, uniqueness: true, on: :create
end