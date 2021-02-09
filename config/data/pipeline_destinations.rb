module PipelineDestinationFactory
  def self.pipeline_destinations
    [
      { name: 'Destination A' },
      { name: 'Destination B' },
      { name: 'Destination C' }
    ]
  end

  def self.seed
    PipelineDestination.create!(pipeline_destinations)
  end
end
