module WorkflowFactory

  def self.workflows
    [
      {name: 'Arrival and issue',                has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'DNA and RNA Extraction Q3',        has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'DNA Extraction Q3',                has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'RNA Extraction Q3',                has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'DNA Extraction BioRobot',          has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'FP lysis',                         has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Human DNA QC',                     has_comment: false, reportable: true, team_name: 'sample_management'  },
      {name: 'Model DNA QC',                     has_comment: false, reportable: true, team_name: 'sample_management'  },
      {name: 'Viral/Bacterial DNA QC',           has_comment: false, reportable: true, team_name: 'sample_management'  },
      {name: 'RNA QC',                           has_comment: false, reportable: true, team_name: 'sample_management'  },
      {name: 'Formatting',                       has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Formatting and 2ndry std QC',      has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Formatting and CGP 2ndry QC',      has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Quantification and Normalisation', has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Fluidigm STD 192:24',              has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Fluidigm CGP 96:96',               has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Storage',                          has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Sequenom prep (Independent)',      has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Sequenom prep (QC)',               has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Other',                            has_comment: true,  reportable: false, team_name: 'sample_management' },
      {name: 'Volume Check',                     has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'Fluidigm DDD 96:96',               has_comment: false, reportable: false, team_name: 'sample_management' },
      {name: 'DNA extraction QS',                has_comment: false, reportable: false, team_name: 'sample_management' }
    ]
  end

  def self.seed
    Workflow.create!(workflows)
  end

end
