class CreateBatchTable < ActiveRecord::Migration
  def change
    create_table(:batches) do |t|
      # id
      t.timestamps
    end
  end
end
