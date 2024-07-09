# frozen_string_literal: true

module AssetPresenter
  # Presenter for showing an asset
  class Asset
    include SharedBehaviour
    include DeploymentInfo
    attr_reader :asset

    def initialize(asset)
      @asset = asset
    end

    def identifier_type
      asset.asset_type.identifier_type
    end

    delegate :id, to: :asset

    delegate :identifier, to: :asset

    delegate :sample_count, to: :asset

    delegate :study, to: :asset

    def project
      asset.project.nil? ? 'Not defined' : asset.project
    end

    def workflow
      asset.workflow.name
    end

    def pipeline_destination
      asset.pipeline_destination.nil? ? 'None' : asset.pipeline_destination.name
    end

    def cost_code
      asset.cost_code.nil? ? 'Not defined' : asset.cost_code.name
    end

    def created_at
      asset.begun_at.strftime('%d/%m/%Y')
    end

    def updated_at
      asset.updated_at.strftime('%d/%m/%Y')
    end

    def comments
      return asset.comment.comment if asset.comment

      ''
    end

    def completed_status_label
      if completed_late?
        return "Late #{asset.time_without_completion - asset.workflow.turn_around_days} " \
                "#{'day'.pluralize(overdue_by)}"
      end
      if completed_early?
        return "Early #{asset.workflow.turn_around_days - asset.time_without_completion} " \
                "#{'day'.pluralize(overdue_by)}"
      end

      'On time' if completed_on_time?
    end

    def completed_at_status
      "#{asset.completed_at.strftime('%d/%m/%Y')} #{"(#{completed_status_label})" if completed_status_label}"
    end

    def completed_at
      return completed_at_status if asset.completed_at
      return 'Due today' if due_today?
      return "Overdue (#{overdue_by} #{'day'.pluralize(overdue_by)})" if overdue?

      "In progress#{in_progress_status}"
    end

    def days_left
      [asset.workflow.turn_around_days - asset.age, 0].max.to_i
    end

    def in_progress_status
      return " (#{days_left} days left)" if asset.workflow.turn_around_days

      ''
    end

    def due_today?
      return false if asset.workflow.turn_around_days.nil?

      (0..1).cover?(time_from_due_date)
    end

    def time_from_due_date
      asset.age - asset.workflow.turn_around_days
    end

    def completed_early?
      return asset.time_without_completion < asset.workflow.turn_around_days if asset.workflow.turn_around_days

      false
    end

    def completed_late?
      return asset.time_without_completion > asset.workflow.turn_around_days if asset.workflow.turn_around_days

      false
    end

    def completed_on_time?
      return asset.time_without_completion == asset.workflow.turn_around_days if asset.workflow.turn_around_days

      false
    end

    def overdue_by
      return 0 if asset.workflow.turn_around_days.nil?

      [time_from_due_date.floor, 0].max
    end

    def overdue?
      asset.completed_at.nil? && overdue_by.positive?
    end

    def completed?
      asset.completed_at.present?
    end

    def batch_id
      asset.batch.id
    end

    def status_code
      return 'success' if completed_early?
      return 'warning' if due_today? || completed_on_time?
      return 'danger' if overdue? || completed_late?

      'default'
    end
  end
end
