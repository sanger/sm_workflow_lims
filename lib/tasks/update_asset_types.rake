namespace :build do
  task asset_types: [:environment] do
    puts 'Create/Update AssetTypes...'
    AssetTypeFactory.asset_types.each do |asset_type_params|
      asset_type = AssetType.find_or_create_by(name: asset_type_params[:name])
      asset_type.update(asset_type_params)
      asset_type.save
    end
  end
end
