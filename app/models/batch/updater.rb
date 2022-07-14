class Batch
  class Updater
    include ActiveModel::Model
    include Batch::DateValidator

    validates :batch, :workflow, presence: true
    validate :valid_date_provided

    attr_accessor :batch, :new_comment, :project, :study, :workflow, :pipeline_destination, :cost_code, :begun_at,
                  :comment, :date

    def update!
      ActiveRecord::Base.transaction do
        batch.assets.update_all(asset_params)
      end
      batch
    end

    private

    def asset_params
      { study_id: study.id, project_id: project.id, workflow_id: workflow.id,
        pipeline_destination_id: pipeline_destination.id, cost_code_id: cost_code.id,
        comment_id: comment_object.id }.tap do |params|
        # Only update begun_at if it's actually provided
        params.merge!(begun_at: date) if date.present?
      end
    end

    def comment_object
      @comment_object ||= existing_comment || (Comment.create!(comment: new_comment) if workflow.has_comment?)
    end

    def existing_comment
      keep, reject = batch.comments.partition { |c| workflow.has_comment? && c.comment == new_comment }
      reject.each(&:destroy)
      keep.first
    end
  end
end
