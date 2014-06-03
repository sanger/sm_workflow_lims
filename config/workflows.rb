module WorkflowFactory

  def self.workflows
    [
      {:name=>'Arrival and issue',                :has_comment=>false},
      {:name=>'DNA and RNA Extraction Q3',        :has_comment=>false},
      {:name=>'DNA Extraction Q3',                :has_comment=>false},
      {:name=>'RNA Extraction Q3',                :has_comment=>false},
      {:name=>'DNA Extraction BioRobot',          :has_comment=>false},
      {:name=>'FP lysis',                         :has_comment=>false},
      {:name=>'Human DNA QC',                     :has_comment=>false},
      {:name=>'Model DNA QC',                     :has_comment=>false},
      {:name=>'Viral/Bacterial DNA QC',           :has_comment=>false},
      {:name=>'RNA QC',                           :has_comment=>false},
      {:name=>'Formatting',                       :has_comment=>false},
      {:name=>'Formatting and 2ndry std QC',      :has_comment=>false},
      {:name=>'Formatting and CGP 2ndry QC',      :has_comment=>false},
      {:name=>'Quantification and Normalisation', :has_comment=>false},
      {:name=>'Fluidigm STD 192:24',              :has_comment=>false},
      {:name=>'Fluidigm CGP 96:96',               :has_comment=>false},
      {:name=>'Storage',                          :has_comment=>false},
      {:name=>'Sequenom prep (Independent)',      :has_comment=>false},
      {:name=>'Sequenom prep (QC)',               :has_comment=>false},
      {:name=>'Other',                            :has_comment=>true}
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
