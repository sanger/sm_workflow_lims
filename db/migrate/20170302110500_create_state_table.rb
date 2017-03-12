class CreateStateTable < ActiveRecord::Migration
  def change
    create_table(:states) do |t|
      # id
      t.string      :name,         null: false
      t.timestamps
    end
  end
end