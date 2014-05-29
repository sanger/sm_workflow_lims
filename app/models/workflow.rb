require 'active_record'

class Workflow < ActiveRecord::Base

  validates_presence_of :name

  has_many :assets

end
