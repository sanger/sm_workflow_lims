# PipelineDestination
class PipelineDestination < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :assets
end
