
class User < ActiveRecord::Base
    has_many :budgets, dependent: :destroy
    has_many :purchase_orders, through: :budgets
    has_secure_password
    validates :username, :password, presence: true

    def slug 
        self.username.gsub("-", " ")
    end

    def self.find_by_slug(slug)
        username= slug.gsub("-", " ")
        User.find_by(username: username)
    end
end