class AddConstrainsOnBegunAt < ActiveRecord::Migration
  def change
    change_column_null :assets, :begun_at, false
  end
end
