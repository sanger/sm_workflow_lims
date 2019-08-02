namespace :asset_types do
  desc 'Update asset_types as requested in SEQ-901'
  task update: [:environment] do
    def asset_type_params_for(new_name)
      AssetTypeFactory.asset_types.detect { |asset| asset[:name] == new_name }
    end

    asset_types_map = [
      ['Plate with Name', asset_type_params_for('High Throughput')],
      ['Plate with Id', asset_type_params_for('Sample Management')],
      ['Tube', asset_type_params_for('Tube')],
      ['Sample', asset_type_params_for('Extraction Sample Tube')]
    ]
    puts 'Update asset_types...'
    asset_types_map.each do |old_name, new_params|
      asset_type = AssetType.find_by(name: old_name) || AssetType.find_by(name: new_params[:name])
      asset_type.update!(new_params)
    end
  end
end
