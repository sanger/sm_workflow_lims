require './config/data/asset_types'
require './lib/utils/dependent_loader'

DependentLoader.start(:asset_types) do |on|
  on.success do
    AssetTypeFactory.seed
  end
end
