class Batch
  class Updater

    include ActiveModel::Model
    include DateValidator

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

  end
end