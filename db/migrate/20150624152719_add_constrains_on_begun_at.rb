class AddConstrainsOnBegunAt < ActiveRecord::Migration[4.2]
  def change
    change_column_null :assets, :begun_at, false
  end
end
