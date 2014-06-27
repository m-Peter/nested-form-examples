class Song < ActiveRecord::Base
  has_one :artist, dependent: :destroy

  validates :title, uniqueness: true
  validates :title, :length, presence: true

  accepts_nested_attributes_for :artist
end