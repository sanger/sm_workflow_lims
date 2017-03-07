require 'active_record'

class FlowStep < ActiveRecord::Base
  belongs_to :flow
  belongs_to :step

  validates_uniqueness_of :step_id, scope: :flow_id

  delegate :name, to: :step

end