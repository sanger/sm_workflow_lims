module WorkflowFactory

  def self.workflows
    [
      {name: 'Arrival and issue',                has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'DNA and RNA Extraction Q3',        has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'DNA Extraction Q3',                has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'RNA Extraction Q3',                has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'DNA Extraction BioRobot',          has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'FP lysis',                         has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Human DNA QC',                     has_comment: false, reportable: true, initial_state: 'in_progress'  },
      {name: 'Model DNA QC',                     has_comment: false, reportable: true, initial_state: 'in_progress'  },
      {name: 'Viral/Bacterial DNA QC',           has_comment: false, reportable: true, initial_state: 'in_progress'  },
      {name: 'RNA QC',                           has_comment: false, reportable: true, initial_state: 'in_progress'  },
      {name: 'Formatting',                       has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Formatting and 2ndry std QC',      has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Formatting and CGP 2ndry QC',      has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Quantification and Normalisation', has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Fluidigm STD 192:24',              has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Fluidigm CGP 96:96',               has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Storage',                          has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Sequenom prep (Independent)',      has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Sequenom prep (QC)',               has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Other',                            has_comment: true,  reportable: false, initial_state: 'in_progress' },
      {name: 'Volume Check',                     has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Fluidigm DDD 96:96',               has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'DNA extraction QS',                has_comment: false, reportable: false, initial_state: 'in_progress' },
      {name: 'Multiteam',                        has_comment: false, reportable: false, initial_state: 'volume_check' },
      {name: 'Multiteam reportable',             has_comment: false, reportable: true,  initial_state: 'volume_check' }
    ]
  end

  def self.seed
    Workflow.create!(workflows)
  end

  def self.update
    ActiveRecord::Base.transaction do
      workflows.each do |at|
        Workflow.find_or_initialize_by(name:at[:name]).tap do |wf|
          wf.update_attributes(at)
        end.save!
      end
    end
  end
end
