class CreateCommentsTable < ActiveRecord::Migration[4.2]
  def change
    create_table(:comments) do |t|
      # id
      t.text :comment, null: true
      t.timestamps
    end
  end
end
