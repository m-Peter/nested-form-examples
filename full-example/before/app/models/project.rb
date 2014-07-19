class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  has_many :people, dependent: :destroy
  belongs_to :owner, :class_name => 'Person', dependent: :destroy

  has_many :project_tags, dependent: :destroy
  has_many :tags, :through => :project_tags, :class_name => 'Tag', dependent: :destroy

  accepts_nested_attributes_for :tasks, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :people, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :owner, :reject_if => :all_blank
  accepts_nested_attributes_for :tags, :allow_destroy => true
  accepts_nested_attributes_for :project_tags, :allow_destroy => true
end
