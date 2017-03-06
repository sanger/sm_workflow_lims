module StepFactory
  def self.steps
    [
      {name: 'in_progress'},
      {name: 'volume_check'},
      {name: 'quant'},
      {name: 'report_required'}
    ]
  end

  def self.seed
    Step.create!(steps)
  end

  def self.update
    ActiveRecord::Base.transaction do
      steps.each do |at|
        Step.find_or_initialize_by(name:at[:name]).tap do |s|
          s.update_attributes(at)
        end.save!
      end
    end
  end
end
