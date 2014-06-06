module AssetTypeFactory

  def self.asset_types
    [
      {:name =>'Plate with Name',     :identifier_type => 'Name', :has_sample_count=>true},
      {:name =>'Plate with Id',       :identifier_type => 'ID'  , :has_sample_count=>true},
      {:name =>'Tube',             :identifier_type => 'ID'  , :has_sample_count=>false},
      {:name =>'Sample', :identifier_type => 'Sample Name'  , :has_sample_count=>false},
    ]
  end

  def self.seed
    AssetType.create!(asset_types)
  end

  def self.update
    ActiveRecord::Base.transaction do
      asset_types.each do |at|
        AssetType.find_or_initialize_by(name:at[:name]).tap do |asset_type|
          asset_type.update_attributes(at)
        end.save!
      end
    end
  end
end
