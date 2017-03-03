class CreateFlowStepTable < ActiveRecord::Migration
  def change
    create_table(:flow_steps) do |t|
      # id
      t.references  :step,   null: false
      t.references  :flow,     null: false
      t.timestamps
      t.integer     :position

    end
  end
end