class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :survey
  validates :content, presence: true

  accepts_nested_attributes_for :answers
end
