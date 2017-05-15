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

    include ActiveModel::Model

    validates_presence_of :workflow, :assets, :asset_type, :study
    validate :valid_date_provided

    attr_accessor :comment, :assets, :study, :project, :workflow, :asset_type, :pipeline_destination, :begun_at, :cost_code, :date

    def create!
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
          begun_at:             date,
          pipeline_destination: pipeline_destination,
          cost_code:     cost_code,
          comment:       comment_object
        }
      end
    end

    #now in 2 places, should be moved somewhere
    def valid_date_provided
      @date = nil
      return true unless begun_at.present?
      begin
        @date = DateTime.strptime(begun_at,'%d/%m/%Y') + 12.hours
        raise ArgumentError unless @date < DateTime.now
      rescue ArgumentError
        errors.add(:dates, 'must be in the format DD/MM/YYYY and cannot be in the future.')
      end
    end
  end

  class Updater

    include ActiveModel::Model

    #Workflow is needed for comment?
    validates_presence_of :batch, :workflow
    validate :valid_date_provided

    attr_accessor :batch, :new_comment, :project, :study, :workflow, :pipeline_destination, :cost_code, :begun_at, :comment, :date

    def update!
      ActiveRecord::Base.transaction do
        batch.assets.update_all(asset_params)
      end
      batch
    end

    private

    def asset_params
      {study: study, project: project, workflow_id: workflow, pipeline_destination_id: pipeline_destination, cost_code_id: cost_code, comment_id: comment_object}.tap do |params|
        # Only update begun at if its actually provided
        params.merge!(begun_at:date) if date.present?
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

    #now in 2 places, should be moved somewhere
    def valid_date_provided
      @date = nil
      return true unless begun_at.present?
      begin
        @date = DateTime.strptime(begun_at,'%d/%m/%Y') + 12.hours
        raise ArgumentError unless @date < DateTime.now
      rescue ArgumentError
        errors.add(:dates, 'must be in the format DD/MM/YYYY and cannot be in the future.')
      end
    end

  end

end
