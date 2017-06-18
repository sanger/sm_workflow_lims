module TeamFactory
  def self.teams
    [
      {name: 'sample_management',
        procedures_attributes: [
          { state_name: 'in_progress', finishing_state_name: 'completed', order: 1},
          { state_name: 'report_required', finishing_state_name: 'reported', order: 2}
        ]
      },
      {name: 'dna',
        procedures_attributes: [
          { state_name: 'volume_check', order: 1},
          { state_name: 'quant', finishing_state_name: 'completed', order: 2},
          { state_name: 'report_required', finishing_state_name: 'reported', order: 3}
        ]
      }
    ]
  end

  def self.seed
    Team.create!(teams)
  end

end