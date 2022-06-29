class Comment < ApplicationRecord
  has_many :assets

  before_destroy :no_assets?

  def no_assets?
    assets.empty? || assets.all? { |a| a.destroyed? }
  end
end
