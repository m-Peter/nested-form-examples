class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  validates :name, uniqueness: true
  validates :name, presence: true

  accepts_nested_attributes_for :tasks
end
