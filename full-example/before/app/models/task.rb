class Task < ActiveRecord::Base
  belongs_to :project
  has_many :sub_tasks
  accepts_nested_attributes_for :sub_tasks, :reject_if => :all_blank, :allow_destroy => true
end
