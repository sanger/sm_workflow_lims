require 'active_record'

class Batch < ActiveRecord::Base

  has_many :assets

  class Creator

    def initialize(*args)
    end

  end

end
