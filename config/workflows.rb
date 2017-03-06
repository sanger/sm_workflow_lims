module WorkflowFactory

  def self.workflows
    [
      {name: 'Arrival and issue',                has_comment: false, reportable: false, flow: 'standard'},
      {name: 'DNA and RNA Extraction Q3',        has_comment: false, reportable: false, flow: 'standard'},
      {name: 'DNA Extraction Q3',                has_comment: false, reportable: false, flow: 'standard'},
      {name: 'RNA Extraction Q3',                has_comment: false, reportable: false, flow: 'standard'},
      {name: 'DNA Extraction BioRobot',          has_comment: false, reportable: false, flow: 'standard'},
      {name: 'FP lysis',                         has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Human DNA QC',                     has_comment: false, reportable: true, flow: 'standard'},
      {name: 'Model DNA QC',                     has_comment: false, reportable: true, flow: 'standard'},
      {name: 'Viral/Bacterial DNA QC',           has_comment: false, reportable: true, flow: 'standard'},
      {name: 'RNA QC',                           has_comment: false, reportable: true, flow: 'standard'},
      {name: 'Formatting',                       has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Formatting and 2ndry std QC',      has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Formatting and CGP 2ndry QC',      has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Quantification and Normalisation', has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Fluidigm STD 192:24',              has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Fluidigm CGP 96:96',               has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Storage',                          has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Sequenom prep (Independent)',      has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Sequenom prep (QC)',               has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Other',                            has_comment: true,  reportable: false, flow: 'standard'},
      {name: 'Volume Check',                     has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Fluidigm DDD 96:96',               has_comment: false, reportable: false, flow: 'standard'},
      {name: 'DNA extraction QS',                has_comment: false, reportable: false, flow: 'standard'},
      {name: 'Multiteam',                        has_comment: false, reportable: false, flow: 'multi_team_quant_essential'},
      {name: 'Multiteam reportable',             has_comment: false, reportable: true,  flow: 'multi_team_quant_essential'}
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
