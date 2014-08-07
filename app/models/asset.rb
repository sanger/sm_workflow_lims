require 'active_record'
require './lib/state_scoping'

class Asset < ActiveRecord::Base

  extend StateScoping

  belongs_to :asset_type
  belongs_to :workflow
  belongs_to :batch
  belongs_to :comment

  after_destroy :remove_comment, :if => :comment

  def remove_comment
    comment.destroy
  end

  def self.with_identifier(search_string)
    search_string.nil? ? all : where(identifier:search_string)
  end

  def self.in_state(state)
    scope_for(state)
  end

  validates_presence_of :workflow, :batch, :identifier, :asset_type

  delegate :identifier_type, :to => :asset_type

  scope :in_progress,     -> { where(completed_at: nil) }
  scope :completed,       -> { where.not(completed_at: nil) }
  scope :reportable,      -> { where(workflows:{reportable:true}) }
  scope :report_required, -> { reportable.completed.where(reported_at:nil) }
  scope :latest_first,    -> { order('created_at DESC') }

  add_state('all',             :all)
  add_state('in_progress',     :in_progress)
  add_state('report_required', :report_required)

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
