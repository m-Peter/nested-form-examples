class Survey < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  validates :name, uniqueness: true
  validates :name, presence: true
  
  accepts_nested_attributes_for :questions, allow_destroy: true
end
