require './lib/client_side_validations'

class CostCode < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  include ClientSideValidations

  validate_with_regexp :name, with: /^[A-Za-z]\d+$/, allow_blank: true,
                              error_msg: 'The cost code should be one letter followed by digits'

  has_many :assets
end
