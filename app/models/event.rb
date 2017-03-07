require 'active_record'

class Event < ActiveRecord::Base
  belongs_to :asset

  validates_presence_of :from, :to

  scope :completed,     -> { where( to: ['report_required', 'done']) }

end