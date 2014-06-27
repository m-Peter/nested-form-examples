class Song < ActiveRecord::Base
  has_one :artist, dependent: :destroy
end
