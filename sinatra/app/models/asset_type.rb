require 'active_record'
require './app/models/asset'

class AssetType < ActiveRecord::Base

  validates_presence_of :name, :identifier_type
  validates_uniqueness_of :name

  has_many :assets

end
