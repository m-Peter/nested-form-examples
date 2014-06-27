class Speaker < ActiveRecord::Base
  has_many :presentations, dependent: :destroy
  belongs_to :conference
end
