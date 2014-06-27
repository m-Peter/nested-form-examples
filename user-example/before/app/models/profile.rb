class Profile < ActiveRecord::Base
  belongs_to :user

  validates :twitter_name, :github_name, uniqueness: true
  validates :twitter_name, presence: true
  validates :github_name, presence: true
end
