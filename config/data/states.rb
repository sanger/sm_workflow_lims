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

end