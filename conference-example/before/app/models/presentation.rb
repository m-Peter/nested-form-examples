class Presentation < ActiveRecord::Base
  belongs_to :speaker
  validates :topic, :duration, presence: true
end
