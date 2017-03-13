require 'active_record'

class Event < ActiveRecord::Base
  belongs_to :asset
  belongs_to :state

  validates_presence_of :asset_id, :state_id

  def state=(state)
    state = State.find_by(name: state) if state.is_a? String
    super
  end

end