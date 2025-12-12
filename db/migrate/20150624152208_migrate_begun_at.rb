class MigrateBegunAt < ActiveRecord::Migration[4.2]
  def up
    ActiveRecord::Base.transaction do
      Asset.update_all('begun_at = created_at')
    end
  end

  def down
    ActiveRecord::Base.transaction do
      Asset.update_all('begun_at = null')
    end
  end
end
