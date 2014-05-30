require 'active_record'

class Asset < ActiveRecord::Base

  belongs_to :asset_type
  belongs_to :workflow
  belongs_to :batch
  belongs_to :comment

  validates_presence_of :workflow, :batch, :identifier, :asset_type

  delegate :identifier_type, :to => :asset_type

  scope :in_progress, -> { where(completed_at: nil) }
  scope :latest_first, -> { order('created_at DESC') }

  class Completer
    def initialize(*args)
    end
  end
end
