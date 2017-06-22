class Batch
  class Creator

    include ActiveModel::Model
    include DateValidator

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
  end
end