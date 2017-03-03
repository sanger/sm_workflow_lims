class CreateStepTable < ActiveRecord::Migration
  def change
    create_table(:steps) do |t|
      # id
      t.string      :name,         null: false
      t.timestamps
    end
  end
end