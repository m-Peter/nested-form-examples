class Conference < ActiveRecord::Base
  has_one :speaker, dependent: :destroy
end
