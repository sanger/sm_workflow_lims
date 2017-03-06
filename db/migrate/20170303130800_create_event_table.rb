class CreateEventTable < ActiveRecord::Migration
  def change
    create_table(:events) do |t|
      # id
      t.references  :asset,   null: false
      t.timestamps
      t.string     :from
      t.string     :to
    end
  end
end