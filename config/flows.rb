module FlowFactory
  def self.flows
    [
      {name: 'standard', steps_names: ['in_progress']},
      {name: 'multi_team_quant_essential', steps_names: ['volume_check', 'quant']}
    ]
  end

  def self.seed
    Flow.create!(flows)
  end

  def self.update
    ActiveRecord::Base.transaction do
      flows.each do |at|
        Flow.find_or_initialize_by(name:at[:name]).tap do |f|
          f.update_attributes(at)
          f.add_steps(at[:steps_names])
        end.save!
      end
    end
  end

end