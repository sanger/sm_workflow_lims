class AssetType < ActiveRecord::Base
  validates :name, :identifier_type, :labware_type, presence: true
  validates :name, uniqueness: true

  has_many :assets
end
