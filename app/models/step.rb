require 'active_record'

class Step < ActiveRecord::Base
  has_many :flow_steps
  has_many :flows, through: :flow_steps

  validates_presence_of :name

end