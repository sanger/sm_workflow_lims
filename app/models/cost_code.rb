
class CostCode < ActiveRecord::Base

  include ClientSideValidations

  has_many :assets

  validates_presence_of :name
  validates_uniqueness_of :name
  validate_with_regexp :name, :with => /^[A-Za-z]\d+$/, :allow_blank => true,
    :error_msg => "The cost code should be one letter followed by digits"

end
