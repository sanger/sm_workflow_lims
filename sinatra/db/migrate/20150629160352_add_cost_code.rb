class AddCostCode < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do
      create_table(:cost_codes) do |t|
        t.column :name, :string, :null => false
      end
      change_table(:assets) do |t|
        t.integer :cost_code_id, :null => true
      end
    end
  end

  def down
    ActiveRecord::Base.transaction do
      remove_column :assets, :cost_code_id
      drop_table :cost_codes
    end
  end
end
