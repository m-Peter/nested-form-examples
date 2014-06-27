class Email < ActiveRecord::Base
  belongs_to :user

  validates :address, uniqueness: true
  validates :address, presence: true
end
