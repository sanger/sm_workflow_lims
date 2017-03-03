require 'active_record'

class FlowStep < ActiveRecord::Base
  belongs_to :flow
  belongs_to :step

  delegate :name, to: :step

end