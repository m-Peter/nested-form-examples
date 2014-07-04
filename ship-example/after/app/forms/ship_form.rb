class ShipForm < AbstractForm
  attributes :name, :crew, :has_astromech, :speed, :armament

  association :pilots, records: 1 do
    attributes :first_name, :last_name, :call_sign

    validates :first_name,
            :presence => true,
            :length => { :maximum => 50 }

    validates :last_name,
              :presence => true,
              :length => { :maximum => 50 }

    validates :call_sign,
            :presence => true,
            :length => { :maximum => 50, :minimum => 5 }
  end

  validates :name,
            :presence => true,
            :length => { :maximum => 50, :minimum => 3 }

  validates :crew,
            :presence => true,
            :inclusion => { :in => 1..5, :message => "must be between 1 and 5" }

  validates :speed,
            :presence => true,
            :inclusion => { :in => 50..200, :message => "must be between 50 and 200" }
end