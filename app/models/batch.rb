require 'active_record'

class Batch < ActiveRecord::Base

  has_many :assets

end
