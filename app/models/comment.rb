require 'active_record'

class Comment < ActiveRecord::Base

  has_many :assets

end
