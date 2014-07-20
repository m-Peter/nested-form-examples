class ProjectFormFixture < AbstractForm
  attributes :name, :description, required: true

  association :tasks, records: 2 do
    attributes :name, :description, required: true
    attribute :done
  end
end