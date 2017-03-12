module WorkflowFactory

  def self.workflows
    [
      {name: 'Arrival and issue',                has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'DNA and RNA Extraction Q3',        has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'DNA Extraction Q3',                has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'RNA Extraction Q3',                has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'DNA Extraction BioRobot',          has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'FP lysis',                         has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Human DNA QC',                     has_comment: false, reportable: true, multi_team_quant_essential: false  },
      {name: 'Model DNA QC',                     has_comment: false, reportable: true, multi_team_quant_essential: false  },
      {name: 'Viral/Bacterial DNA QC',           has_comment: false, reportable: true, multi_team_quant_essential: false  },
      {name: 'RNA QC',                           has_comment: false, reportable: true, multi_team_quant_essential: false  },
      {name: 'Formatting',                       has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Formatting and 2ndry std QC',      has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Formatting and CGP 2ndry QC',      has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Quantification and Normalisation', has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Fluidigm STD 192:24',              has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Fluidigm CGP 96:96',               has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Storage',                          has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Sequenom prep (Independent)',      has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Sequenom prep (QC)',               has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Other',                            has_comment: true,  reportable: false, multi_team_quant_essential: false },
      {name: 'Volume Check',                     has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Fluidigm DDD 96:96',               has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'DNA extraction QS',                has_comment: false, reportable: false, multi_team_quant_essential: false },
      {name: 'Multiteam',                        has_comment: false, reportable: false, multi_team_quant_essential: true },
      {name: 'Multiteam reportable',             has_comment: false, reportable: true,  multi_team_quant_essential: true }
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
