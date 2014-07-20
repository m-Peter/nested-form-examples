class ProjectFormFixture < AbstractForm
  attributes :name, :description, :owner_id

  association :tasks, records: 2 do
    attributes :name, :description, :done
  end

  association :contributors, records: 2 do
    attributes :name, :description, :role
  end
end