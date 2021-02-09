class Batch < ActiveRecord::Base
  has_many :assets
  has_many :comments, through: :assets

  before_destroy :remove_assets

  def remove_assets
    ActiveRecord::Base.transaction do
      self.assets.each(&:destroy!)
    end
  end
end
