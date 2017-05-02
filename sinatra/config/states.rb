module StateFactory
  def self.states
    [
      {name: 'in_progress'},
      {name: 'volume_check'},
      {name: 'quant'},
      {name: 'completed'},
      {name: 'report_required'},
      {name: 'reported'}
    ]
  end

  def self.seed
    State.create!(states)
  end

  def self.update
    ActiveRecord::Base.transaction do
      states.each do |at|
        State.find_or_initialize_by(name:at[:name]).tap do |s|
          s.update_attributes(at)
        end.save!
      end
    end
  end
end