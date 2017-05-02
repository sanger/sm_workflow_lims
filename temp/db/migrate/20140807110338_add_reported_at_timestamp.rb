class AddReportedAtTimestamp < ActiveRecord::Migration


  def change
    add_column :assets, :reported_at, :datetime
  end

end
