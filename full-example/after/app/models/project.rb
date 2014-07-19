class Project < ActiveRecord::Base
  has_many :tasks
  has_many :people
  belongs_to :owner, :class_name => 'Person'

  has_many :project_tags
  has_many :tags, :through => :project_tags, :class_name => 'Tag'
end
