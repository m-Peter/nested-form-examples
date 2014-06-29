class User < ActiveRecord::Base
  has_secure_password

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  validates_length_of :password, minimum: 6, on: :create

  before_create :generate_token

  has_one :profile
  accepts_nested_attributes_for :profile

  def subscribed
    subscribed_at
  end

  def subscribed=(checkbox)
    subscribed_at = Time.zone.now if checkbox == "1"
  end

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while User.exists?(token: token)
  end
end
