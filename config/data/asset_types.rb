module AssetTypeFactory

  def self.asset_types
    [
      {:name =>'Plate with Name', :identifier_type => 'Name',   :has_sample_count=>true, :identifier_data_type=>'alphanumeric'},
      {:name =>'Plate with Id',   :identifier_type => 'ID'  ,   :has_sample_count=>true, :identifier_data_type=>'numeric'},
      {:name =>'Tube',            :identifier_type => 'ID'  ,   :has_sample_count=>false, :identifier_data_type=>'alphanumeric'},
      {:name =>'Sample',          :identifier_type => 'Name'  , :has_sample_count=>false, :identifier_data_type=>'alphanumeric'}
    ]
  end

  def self.seed
    AssetType.create!(asset_types)
  end

end
