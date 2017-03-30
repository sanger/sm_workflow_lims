require 'active_record'

class Event < ActiveRecord::Base
  belongs_to :asset
  belongs_to :state

  validates_presence_of :asset_id, :state_id

  attr_accessor :state_name

  def state_name=(state_name)
    self.state = State.find_by(name: state_name)
  end

  def self.latest_per_asset
    Event.group(:asset_id).maximum(:id).values
  end

end