
class PurchaseOrder < ActiveRecord::Base
    belongs_to :vendor
    belongs_to :budget
    validates :po_number, :po_authorized_amount, presence: true
end