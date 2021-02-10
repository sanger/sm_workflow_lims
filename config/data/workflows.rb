# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/MethodLength
module WorkflowFactory
  def self.workflows
    [
      {
        name: 'Arrival and issue',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'DNA and RNA Extraction Q3',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'DNA Extraction Q3',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'RNA Extraction Q3',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'DNA Extraction BioRobot',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress', active: false
      },
      {
        name: 'FP lysis',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Human DNA QC',
        has_comment: false, reportable: true,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Model DNA QC',
        has_comment: false, reportable: true,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Viral/Bacterial DNA QC',
        has_comment: false, reportable: true,
        initial_state_name: 'in_progress'
      },
      {
        name: 'RNA QC',
        has_comment: false, reportable: true,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Formatting',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Formatting and 2ndry std QC',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Formatting and CGP 2ndry QC',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Quantification and Normalisation',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Fluidigm STD 192:24',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Fluidigm CGP 96:96',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Storage',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Sequenom prep (Independent)',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Sequenom prep (QC)',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Other',
        has_comment: true,  reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Volume Check',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'Fluidigm DDD 96:96',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress'
      },
      {
        name: 'DNA extraction QS',
        has_comment: false, reportable: false,
        initial_state_name: 'in_progress', active: false
      }
    ]
  end

  def self.seed
    Workflow.create!(workflows)
  end
end
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/MethodLength
