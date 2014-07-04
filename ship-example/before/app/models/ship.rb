class Ship < ActiveRecord::Base
  has_many :pilots
  accepts_nested_attributes_for :pilots,
                                :reject_if => :all_blank,
                                :allow_destroy => true

  validates_associated :pilots

  validates :name,
            :presence => true,
            :uniqueness => { :case_sensitive => false },
            :length => { :maximum => 50, :minimum => 3 }

  validates :crew,
            :presence => true,
            :inclusion => { :in => 1..5, :message => "must be between 1 and 5" }

  validates :speed,
            :presence => true,
            :inclusion => { :in => 50..200, :message => "must be between 50 and 200" }
end
