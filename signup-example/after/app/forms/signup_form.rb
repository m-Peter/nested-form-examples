class SignupForm < AbstractForm
  attributes :username, :email, :password, :password_confirmation

  association :profile do
    attributes :twitter_name, :github_name, :bio
  end

  validates_presence_of :username
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  validates_length_of :password, minimum: 6

  def subscribed
    model.subscribed_at
  end

  def subscribed=(checkbox)
    model.subscribed_at = Time.zone.now if checkbox == "1"
  end
end