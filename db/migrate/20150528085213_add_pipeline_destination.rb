class AddPipelineDestination < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do
      create_table(:pipeline_destinations) do |t|
        t.column :name, :string
      end
      change_table(:assets) do |t|
        t.references :pipeline_destination, null: true
      end
    end
  end

  def down
    ActiveRecord::Base.transaction do
      remove_column :assets, :pipeline_destination_id
      drop_table :pipeline_destinations
    end
  end
end
