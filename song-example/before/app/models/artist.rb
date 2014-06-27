class Artist < ActiveRecord::Base
  has_one :producer, dependent: :destroy
  belongs_to :song

  validates :name, uniqueness: true
  validates :name, presence: true

  accepts_nested_attributes_for :producer
end
