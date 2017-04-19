require 'active_record'

class Event < ActiveRecord::Base
  belongs_to :asset
  belongs_to :state

  validates_presence_of :asset_id, :state_id

  attr_accessor :state_name

  def state_name=(state_name)
    self.state = State.find_by(name: state_name)
  end

  def self.latest_event_per_asset
    select("MAX(id)").group("asset_id")
  end

  def self.with_last_state(state)
    where(id: latest_event_per_asset, state_id: state.id)
  end

  def self.completed_between(start_date, end_date)
    state = State.find_by(name: 'completed').id
    where("events.created_at BETWEEN ? AND ? AND events.state_id = ?", start_date, end_date, state)
  end

end