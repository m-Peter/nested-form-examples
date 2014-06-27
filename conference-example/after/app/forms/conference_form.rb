class ConferenceForm < AbstractForm
  attributes :name, :city

  association :speaker do
    attribute :name, :occupation

    association :presentations, records: 2 do
      attribute :topic, :duration

      validates :topic, :duration, presence: true
    end

    validates :name, :occupation, presence: true
  end

  validates :name, :city, presence: true
end