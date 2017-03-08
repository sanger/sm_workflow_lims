require 'active_record'

class Flow < ActiveRecord::Base
  has_many :flow_steps, dependent: :destroy
  has_many :steps, through: :flow_steps
  has_many :workflows

  validates_presence_of :name
  validates_uniqueness_of :name

  attr_accessor :steps_names

  def initialize(attributes={})
    super
    add_steps(attributes[:steps_names])
  end

  def initial_step
    flow_steps.order(:position).first
  end

  def initial_step_name
    flow_steps.order(:position).first.name
  end

  def next_step(flow_step)
    flow_steps.where("position > ?", flow_step.position).first
  end

  def next_step_name(current_step_name)
    flow_step = flow_steps.select {|flow_step| flow_step.name == current_step_name}.first
    next_step(flow_step).try(:name) || 'done'
  end

  def add_steps(steps_names)
    return unless steps_names.present?
    steps_names.each do |name|
      flow_step = FlowStep.create!(step: Step.find_by(name: name), flow: self, position: flow_steps.count)
    end
  end

end