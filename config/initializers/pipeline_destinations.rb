require './config/data/pipeline_destinations'

DependentLoader.start(:pipeline_destinations) do |on|
  on.success do
    PipelineDestinationFactory.seed
  end
end
