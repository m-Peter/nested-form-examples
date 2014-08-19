class ShipForm < ActiveForm::Base
  self.main_model = :ship
  
  attributes :name, :crew, :speed, :armament, required: true
  attribute :has_astromech

  association :pilots, records: 1 do
    attributes :first_name, :last_name, :call_sign, required: true

    validates :first_name, :length => { :maximum => 50 }
    validates :last_name, :length => { :maximum => 50 }
    validates :call_sign, :length => { :maximum => 50, :minimum => 5 }
  end

  validates :name, :length => { :maximum => 50, :minimum => 3 }
  validates :crew, :inclusion => { :in => 1..5, :message => "must be between 1 and 5" }
  validates :speed, :inclusion => { :in => 50..200, :message => "must be between 50 and 200" }
end