require 'active_record'

class Event < ActiveRecord::Base
  belongs_to :asset
  belongs_to :state

  validates_presence_of :asset_id, :state_id

  def state=(state)
    state = State.find_by(name: state) if state.is_a? String
    super
  end

  def self.with_last_state(state)
    order("id desc").group("asset_id").having(state_id: state.id)
  end

end