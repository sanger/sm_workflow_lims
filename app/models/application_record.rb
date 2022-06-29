# frozen_string_literal: true

# Basic base class for all ActiveRecord::Base records in Sequencescape
# @see https://www.rubydoc.info/github/RailsApps/learn-rails/master/ApplicationRecord
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
