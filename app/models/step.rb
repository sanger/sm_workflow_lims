require 'active_record'

class Step < ActiveRecord::Base
  has_many :flow_steps, dependent: :destroy
  has_many :flows, through: :flow_steps

  validates_presence_of :name
  validates_uniqueness_of :name

end