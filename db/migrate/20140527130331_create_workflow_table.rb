class CreateWorkflowTable < ActiveRecord::Migration
  def change
    create_table(:workflows) do |t|
      # id
      t.string      :name,         :null => false
      t.boolean     :has_comment,  :null => false, :default => false
      t.timestamps
    end
  end
end
