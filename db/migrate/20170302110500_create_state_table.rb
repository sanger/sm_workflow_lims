class CreateStateTable < ActiveRecord::Migration[4.2]
  def change
    create_table(:states) do |t|
      # id
      t.string :name, null: false
      t.timestamps
    end
  end
end
