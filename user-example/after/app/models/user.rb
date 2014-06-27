class User < ActiveRecord::Base
  has_one :email, dependent: :destroy
  has_one :profile, dependent: :destroy
end
