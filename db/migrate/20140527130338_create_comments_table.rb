class CreateCommentsTable < ActiveRecord::Migration
  def change
    create_table(:comments) do |t|
      # id
      t.text :comment, :null => true
      t.timestamps
    end
  end
end
