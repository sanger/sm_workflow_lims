class CreateEventTable < ActiveRecord::Migration
  def change
    create_table(:events) do |t|
      # id
      t.references  :asset,   null: false
      t.references  :state,   null: false
      t.timestamps
    end
  end
end
