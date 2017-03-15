require 'active_record'

class State < ActiveRecord::Base
  has_many :events
  has_many :workflows

  validates_presence_of :name
  validates_uniqueness_of :name

  def default?
    name == 'in_progress'
  end

  def multi_team_quant_essential?
    !default?
  end

end