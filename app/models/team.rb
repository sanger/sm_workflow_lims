class Team < ActiveRecord::Base
  has_many :procedures, dependent: :destroy
  accepts_nested_attributes_for :procedures

  has_many :states, through: :procedures
  has_many :workfows

  validates :name, presence: true

  def first_state
    states.first
  end

  def humanized_name
    name.humanize
  end

  def procedure_for(state)
    procedures.where(state: state).first
  end

  def procedure_after(current_procedure)
    procedures.where(order: current_procedure.order+1).first
  end

end
