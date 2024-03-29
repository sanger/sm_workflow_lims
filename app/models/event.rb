class Event < ApplicationRecord
  belongs_to :asset
  belongs_to :state

  attr_accessor :state_name

  def state_name=(state_name)
    self.state = State.find_by(name: state_name)
  end

  def self.latest_event_per_asset
    select('MAX(id)').group('asset_id')
  end

  def self.with_last_state(state)
    where(id: latest_event_per_asset, state:)
  end

  def self.completed_between(start_date, end_date)
    state = State.find_by(name: 'completed')
    where(created_at: start_date..end_date, state:)
  end
end
