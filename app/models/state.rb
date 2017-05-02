class State < ActiveRecord::Base
  has_many :events
  has_many :workflows

  validates_presence_of :name
  validates_uniqueness_of :name

  def default?
    name == 'in_progress'
  end

  # Multi-Team quant essential is hopefully a temporary
  # situation, and should be replaced soon with something
  # less hard-coded. 15/03/2017
  def multi_team_quant_essential?
    !default?
  end

end
