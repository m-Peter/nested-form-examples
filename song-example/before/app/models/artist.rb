class Artist < ActiveRecord::Base
  has_one :producer, dependent: :destroy
  belongs_to :song
end
