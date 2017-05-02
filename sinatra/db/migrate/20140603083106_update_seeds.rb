class UpdateSeeds < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do
      require './config/asset_types'
      require './config/workflows'
      AssetTypeFactory.update
      WorkflowFactory.update
    end
  end

  def down
    ActiveRecord::Base.transaction do
      require './config/asset_types'
      require './config/workflows'
      AssetTypeFactory.update
      WorkflowFactory.update
    end
  end
end
