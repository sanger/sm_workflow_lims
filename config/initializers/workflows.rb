require './config/data/workflows'

DependentLoader.start(:workflows) do |on|
  on.success do
    WorkflowFactory.seed
  end
end
