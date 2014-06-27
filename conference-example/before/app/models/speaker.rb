class Speaker < ActiveRecord::Base
  has_many :presentations, dependent: :destroy
  belongs_to :conference
  validates :name, uniqueness: true
  validates :name, :occupation, presence: true

  accepts_nested_attributes_for :presentations
end
