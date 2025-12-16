class AddBegunAtTimestamp < ActiveRecord::Migration[4.2]
  def change
    add_column :assets, :begun_at, :datetime
  end
end
