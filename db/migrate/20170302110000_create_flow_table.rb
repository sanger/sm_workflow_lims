class CreateFlowTable < ActiveRecord::Migration
  def change
    create_table(:flows) do |t|
      # id
      t.string      :name,         null: false
      t.boolean     :reportable,   null: false, default: false
      t.boolean     :multi_team_quant_essential,   null: false, default: false
      t.timestamps
    end
  end
end