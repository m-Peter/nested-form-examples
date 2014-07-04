class Ship < ActiveRecord::Base
  has_many :pilots

  validates :name, :uniqueness => { :case_sensitive => false }
end
