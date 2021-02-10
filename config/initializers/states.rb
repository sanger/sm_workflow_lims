require './config/data/states'

DependentLoader.start(:states) do |on|
  on.success do
    StateFactory.seed
  end
end
