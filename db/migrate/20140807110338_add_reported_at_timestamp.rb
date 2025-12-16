class AddReportedAtTimestamp < ActiveRecord::Migration[4.2]
  def change
    add_column :assets, :reported_at, :datetime
  end
end
