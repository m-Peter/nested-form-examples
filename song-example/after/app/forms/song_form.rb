class SongForm < AbstractForm
  attributes :title, :length, required: true

  association :artist do
    attribute :name, required: true

    association :producer do
      attributes :name, :studio, required: true
    end
  end
end