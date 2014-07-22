class ProjectForm < AbstractForm
  attributes :name, :description, :owner_id

  association :tasks do
    attributes :name, :description, :done

    association :sub_tasks do
      attributes :name, :description, :done
    end
  end

  association :contributors do
    attributes :name, :description, :role
  end

  association :project_tags do
    association :tag do
      attribute :name
    end
  end

  association :owner do
    attributes :name, :description, :role
  end
end