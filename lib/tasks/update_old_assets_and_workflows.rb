require "./app"

namespace :old do
  task :update do

    def update_workflows
      Workflow.where(turn_around_days: nil).each do |workflow|
        workflow.update_attributes!(initial_state: 'in_progress')
      end
    end

    def update_in_progress_assets
      Asset.in_progress.each do |asset|
        if asset.events.empty?
          asset.events.create!(state: 'in_progress', created_at: asset.begun_at)
        end
      end
    end

    def update_completed_assets
      Asset.completed.each do |asset|
        if asset.events.empty?
          asset.events.create!(state: 'in_progress', created_at: asset.begun_at)
          asset.events.create!(state: 'completed', created_at: asset.completed_at)
        end
      end
    end

    def update_report_required_assets
      Asset.report_required.each do |asset|
        asset.events.create!(state: 'report_required', created_at: asset.completed_at)
      end
    end

    def update_reported_assets
      Asset.reported.each do |asset|
        asset.events.create!(state: 'reported', created_at: asset.reported_at)
      end
    end

    puts "Update workflows"
    update_workflows
    puts "Updating in_progress assets"
    update_in_progress_assets
    puts "Updating completed assets"
    update_completed_assets
    puts "Updating report_required assets"
    update_report_required_assets
    puts "Updating reported assets"
    update_reported_assets

  end
end

