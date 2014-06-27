class Conference < ActiveRecord::Base
  has_one :speaker, dependent: :destroy
  validates :name, uniqueness: true
  validates :name, :city, presence: true

  accepts_nested_attributes_for :speaker
end
