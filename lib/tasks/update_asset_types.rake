namespace :asset_types do
  desc 'Update asset_types to new version of the DB (SEQ-901)'
  task update: [:environment, 'asset_types:rename', 'asset_types:build']

  desc 'Rename asset_types as requested in SEQ-901'
  task rename: [:environment] do
    asset_types_map = [
      ['Plate with Name', 'High Throughput'],
      ['Plate with Id', 'Sample Management'],
      ['Sample', 'Extraction Sample Tube']
    ]
    puts 'Rename asset_types...'
    asset_types_map.each do |old_name, new_name|
      asset_type = AssetType.find_by!(name: old_name)
      asset_type.update(name: new_name)
      asset_type.save
    end
  end

  desc 'Create or update asset_types based on AssetTypeFactory'
  task build: [:environment] do
    puts 'Create/Update asset_types...'
    AssetTypeFactory.asset_types.each do |asset_type_params|
      asset_type = AssetType.find_or_create_by(name: asset_type_params[:name])
      asset_type.update(asset_type_params)
      asset_type.save
    end
  end
end
