class ProjectFormFixture < AbstractForm
  attributes :name, :description, required: true

  association :tasks do
    attributes :name, :description, :done, required: true
  end
end