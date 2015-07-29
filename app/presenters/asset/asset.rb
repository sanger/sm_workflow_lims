require './app/presenters/presenter'

module Presenter::AssetPresenter
  class Asset < Presenter

    attr_reader :asset

    def initialize(asset)
      @asset = asset
    end

    def identifier_type
      asset.asset_type.identifier_type
    end

    def id
      asset.id
    end

    def identifier
      asset.identifier
    end

    def sample_count
      asset.sample_count
    end

    def study
      asset.study
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

    def completed_at
      return asset.completed_at.strftime('%d/%m/%Y') if asset.completed_at
      return 'Due today' if due_today?
      return "Overdue (#{overdue_by} #{'day'.pluralize(overdue_by)})" if overdue?
      'In progress'
    end

    def due_today?
      return false if asset.workflow.turn_around_days.nil?
      (0..1).include?(time_from_due_date)
    end

    def time_from_due_date
      asset.age - asset.workflow.turn_around_days
    end

    def overdue_by
      return 0 if asset.workflow.turn_around_days.nil?
      [(time_from_due_date).floor,0].max
    end

    def overdue?
      asset.completed_at.nil? && overdue_by > 0
    end

    def completed?
      asset.completed_at.present?
    end

    def batch_id
      asset.batch.id
    end

    def status_code
      return 'success' if asset.completed_at
      return 'warning' if due_today?
      return 'danger' if overdue?
      'default'
    end
  end
end
