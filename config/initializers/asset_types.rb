require './config/data/asset_types'

DependentLoader.start(:asset_types) do |on|
  on.success do
    AssetTypeFactory.seed
  end
end