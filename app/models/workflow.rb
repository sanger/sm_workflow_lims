class Workflow < ActiveRecord::Base

  has_many :assets
  belongs_to :initial_state, class_name: 'State'
  belongs_to :team

  validates_presence_of :name, :team
  validates_uniqueness_of :name
  validates_numericality_of :turn_around_days, :greater_than_or_equal_to => 0, :allow_nil => true, :only_integer => true

  delegate :first_state, to: :team

  def team_name=(team_name)
    self.team = Team.find_by(name: team_name)
  end

  def humanized_team_name
    team.humanized_name
  end

end
