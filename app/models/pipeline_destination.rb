require 'active_record'

class PipelineDestination < ActiveRecord::Base

  validates_presence_of :name

  has_many :assets

end
