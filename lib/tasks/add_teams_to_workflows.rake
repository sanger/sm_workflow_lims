
namespace :workflows do
  task add_teams: :environment do

    def add_teams_to_workflows
      Workflow.all.each do |workflow|
        if workflow.initial_state == State.find_by(name: 'in_progress')
          workflow.team = Team.find_by(name: 'sample_management')
        elsif workflow.initial_state == State.find_by(name: 'volume_check')
          workflow.team = Team.find_by(name: 'dna')
        end
        workflow.save
      end
    end

    puts "Adding teams to workflows"
    add_teams_to_workflows
    puts "Done"

  end
end