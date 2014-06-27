class ProjectForm < AbstractForm
  attribute :name

  association :tasks, records: 3 do
    attribute :name

    validates :name, presence: true
  end

  validates :name, presence: true
end