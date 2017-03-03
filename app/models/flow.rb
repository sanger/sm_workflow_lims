require 'active_record'

class Flow < ActiveRecord::Base
  has_many :flow_steps
  has_many :steps, through: :flow_steps
  has_many :workflows

  validates_presence_of :name

  def initial_step
    flow_steps.order(:position).first
  end

  def initial_step_name
    flow_steps.order(:position).first.name
  end

  def next_step(flow_step)
    flow_steps.where("position > ?", flow_step.position).first
  end

  def next_step_by_name(step_name)
    flow_step = flow_steps.select {|flow_step| flow_step.name == step_name}.first
    next_step(flow_step)
  end

end