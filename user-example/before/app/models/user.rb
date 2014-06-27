class User < ActiveRecord::Base
  act_as_gendered
  has_one :email, dependent: :destroy
  has_one :profile, dependent: :destroy

  accepts_nested_attributes_for :email, :profile

  validates :name, uniqueness: true
  validates :name, :age, :gender, presence: true
  validates :name, length: { in: 6..20 }
  validates :age, numericality: { only_integer: true }
end
