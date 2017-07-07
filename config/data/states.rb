module StateFactory
  def self.states_names
    ['in_progress', 'volume_check', 'quant', 'completed', 'report_required',
      'reported', 'cross_charge', 'charged']
  end

  def self.seed
    states_names.each do |state_name|
      State.find_or_create_by(name: state_name)
    end
  end

end