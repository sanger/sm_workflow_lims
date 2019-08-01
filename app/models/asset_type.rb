class AssetType < ActiveRecord::Base

  validates_presence_of :name, :identifier_type, :labware_type
  validates_uniqueness_of :name

  has_many :assets

end
