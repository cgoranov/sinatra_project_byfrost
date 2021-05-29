
class PurchaseOrder < ActiveRecord::Base
    belongs_to :vendor
    belongs_to :budget
end