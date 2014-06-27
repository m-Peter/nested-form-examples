class SongForm < AbstractForm
  attributes :title, :length

  association :artist do
    attribute :name

    association :producer do
      attributes :name, :studio

      validates :name, :studio, presence: true
    end

    validates :name, presence: true
  end

  validates :title, :length, presence: true
end