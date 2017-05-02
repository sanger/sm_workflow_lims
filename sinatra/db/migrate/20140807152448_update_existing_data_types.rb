class UpdateExistingDataTypes < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      require './config/asset_types'
      AssetTypeFactory.update
    end
  end
end
