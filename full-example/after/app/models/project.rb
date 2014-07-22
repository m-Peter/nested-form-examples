class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  has_many :contributors, :class_name => 'Person', dependent: :destroy
  belongs_to :owner, :class_name => 'Person', dependent: :destroy

  has_many :project_tags, dependent: :destroy
  has_many :tags, :through => :project_tags, :class_name => 'Tag', dependent: :destroy
end
