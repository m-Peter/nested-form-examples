class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :survey

  accepts_nested_attributes_for :answers
end
