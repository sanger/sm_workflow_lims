module StateFactory
  def self.states
    [
      {name: 'in_progress'},
      {name: 'volume_check'},
      {name: 'quant'},
      {name: 'completed'},
      {name: 'report_required'},
      {name: 'reported'},
      {name: 'cross_charge'},
      {name: 'charged'}
    ]
  end

  def self.seed
    State.create!(states)
  end

end