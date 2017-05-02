class AddReportableToWorkflows < ActiveRecord::Migration
  def change
    add_column :workflows, :reportable, :boolean, :default => false, :null => false
  end
end
