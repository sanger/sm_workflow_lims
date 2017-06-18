class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|

      t.timestamps null: false
      t.belongs_to :team, index: true
      t.belongs_to :state, index: true, null: false
      t.belongs_to :finishing_state, index: true
      t.integer :order, null: false
    end
  end
end
