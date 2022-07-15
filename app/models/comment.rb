class Comment < ApplicationRecord
  has_many :assets

  before_destroy :no_assets?

  def no_assets?
    return if assets.empty? || assets.all? { |a| a.destroyed? }

    throw(:abort)
  end
end
