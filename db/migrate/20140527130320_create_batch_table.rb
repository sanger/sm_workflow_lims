class CreateBatchTable < ActiveRecord::Migration[4.2]
  def change
    create_table(:batches) do |t|
      # id
      t.timestamps
    end
  end
end
