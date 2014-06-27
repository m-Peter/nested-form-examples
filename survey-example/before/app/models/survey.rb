class Survey < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  validates :name, uniqueness: true
  
  accepts_nested_attributes_for :questions
end
