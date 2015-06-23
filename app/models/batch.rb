require 'active_record'

class Batch < ActiveRecord::Base

  has_many :assets
  has_many :comments, :through => :assets

  before_destroy :remove_assets

  def remove_assets
    ActiveRecord::Base.transaction do
      self.assets.each(&:destroy!)
    end
  end

  class Creator

    attr_reader :comment, :assets, :study, :workflow, :asset_type, :pipeline_destination

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(study:,assets:,asset_type:,workflow:,pipeline_destination:,comment:nil)
      @study = study
      @assets = assets
      @asset_type = asset_type
      @workflow = workflow
      @pipeline_destination = pipeline_destination
      @comment = comment
    end

    def do!
      ActiveRecord::Base.transaction do
        Batch.new.tap do |batch|
          batch.assets.build(assets_map)
          batch.save!
        end
      end
    end

    def comment_object
      @comment_object ||= Comment.create!(comment:comment) if workflow.has_comment?
    end

    def assets_map
      assets.map do |asset_params|
        sample_count = asset_type.has_sample_count? ? asset_params[:sample_count] : 1
        {
          identifier:    asset_params[:identifier],
          sample_count:  sample_count,
          asset_type:    asset_type,
          study:         study,
          workflow:      workflow,
          pipeline_destination: pipeline_destination,
          comment:       comment_object
        }
      end
    end

  end

  class Updater

    attr_reader :batch, :new_comment, :study, :workflow, :pipeline_destination

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(study:,workflow:,pipeline_destination:,comment:,batch:)
      @batch = batch
      @study = study
      @workflow = workflow
      @pipeline_destination = pipeline_destination
      @new_comment = comment
    end

    def do!
      ActiveRecord::Base.transaction do
        batch.assets.update_all(study:study,workflow_id:workflow,pipeline_destination_id:pipeline_destination,comment_id:comment_object)
      end
      batch
    end

    private

    def comment_object
      @comment_object ||= existing_comment || ( Comment.create!(comment:new_comment) if workflow.has_comment? )
    end

    def existing_comment
      keep, reject = batch.comments.partition {|c| workflow.has_comment? && c.comment == new_comment}
      reject.each(&:destroy)
      keep.first
    end

  end

end
