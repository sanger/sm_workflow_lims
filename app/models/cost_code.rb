require './lib/client_side_validations'

class CostCode < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  include ClientSideValidations

  validate_with_regexp :name, :with => /^[A-Za-z]\d+$/, :allow_blank => true,
    :error_msg => "The cost code should be one letter followed by digits"

  has_many :assets

end
