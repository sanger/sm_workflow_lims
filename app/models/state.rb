class State < ActiveRecord::Base
  has_many :events
  has_many :workflows

  has_many :procedures
  has_many :teams, through: :procedures

  validates :name, presence: true, uniqueness: true

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
