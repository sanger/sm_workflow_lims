require 'active_record'

class Asset < ActiveRecord::Base

  belongs_to :asset_type
  belongs_to :workflow
  belongs_to :batch
  belongs_to :comment
  
  before_destroy :remove_comment
  
  def remove_comment
    unless self.comment.nil?
      if ((self.comment.assets.select {|asset| !asset.destroyed?}.size) <= 1)
        ActiveRecord::Base.transaction do
          self.comment.destroy!
        end
      end
    end
  end

  validates_presence_of :workflow, :batch, :identifier, :asset_type

  delegate :identifier_type, :to => :asset_type

  scope :in_progress, -> { where(completed_at: nil) }
  scope :latest_first, -> { order('created_at DESC') }

  default_scope { includes(:workflow,:asset_type,:comment,:batch) }

  class Completer

    attr_reader :time, :assets

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(time:,assets:)
      @time = time
      @assets = assets
    end

    def do!
      ActiveRecord::Base.transaction do
        assets.each {|a| a.update_attributes!(completed_at:time) }
      end
    end

  end
end
