class Pilot < ActiveRecord::Base
  belongs_to :ship

  validates :call_sign, :uniqueness => { :case_sensitive => false }
end
