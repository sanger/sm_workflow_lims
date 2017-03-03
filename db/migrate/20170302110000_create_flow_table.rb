class CreateFlowTable < ActiveRecord::Migration
  def change
    create_table(:flows) do |t|
      # id
      t.string      :name,         null: false
      t.timestamps
    end
  end
end