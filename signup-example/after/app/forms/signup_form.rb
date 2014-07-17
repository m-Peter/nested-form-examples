class SignupForm < AbstractForm
  attributes :email, :password, :password_confirmation
  attributes :username, required: true

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

  def save
    if valid?
      generate_token
      model.save
      true
    else
      false
    end
  end

  def generate_token
    begin
      model.token = SecureRandom.hex
    end while User.exists?(token: model.token)
  end
end