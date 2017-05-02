class AddBegunAtTimestamp < ActiveRecord::Migration
  def change
    add_column :assets, :begun_at, :datetime
  end
end
