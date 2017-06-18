require './config/data/teams'

DependentLoader.start(:teams) do |on|
  on.success do
    TeamFactory.seed
  end
end