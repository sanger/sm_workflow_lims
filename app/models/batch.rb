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

    attr_reader :comment, :assets, :study, :project, :workflow, :asset_type, :pipeline_destination, :begun_at, :cost_code

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(study:,project:,assets:,asset_type:,workflow:,pipeline_destination:,cost_code:, comment:nil,begun_at:nil)
      @study = study
      @project = project
      @assets = assets
      @asset_type = asset_type
      @workflow = workflow
      @pipeline_destination = pipeline_destination
      @cost_code = cost_code
      @comment = comment
      @begun_at = begun_at
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
          identifier:           asset_params[:identifier],
          sample_count:         sample_count,
          asset_type:           asset_type,
          study:                study,
          project:              project,
          workflow:             workflow,
          begun_at:             begun_at,
          pipeline_destination: pipeline_destination,
          cost_code:     cost_code,
          comment:       comment_object
        }
      end
    end

  end

  class Updater

    attr_reader :batch, :new_comment, :project, :study, :workflow, :pipeline_destination, :cost_code, :begun_at

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(study:,project:,workflow:,pipeline_destination:,cost_code:,comment:,batch:,begun_at:nil)
      @batch = batch
      @study = study
      @project = project
      @workflow = workflow
      @pipeline_destination = pipeline_destination
      @cost_code = cost_code
      @new_comment = comment
      @begun_at = begun_at
    end

    def do!
      ActiveRecord::Base.transaction do
        batch.assets.update_all(asset_params)
      end
      batch
    end

    private

    def asset_params
      {study: study, project: project, workflow_id: workflow, pipeline_destination_id: pipeline_destination, cost_code_id: cost_code, comment_id: comment_object}.tap do |params|
        # Only update begun at if its actually provided
        params.merge!(begun_at:begun_at) if begun_at
      end
    end

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
