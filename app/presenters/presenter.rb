class Presenter

  attr_reader :object

  def initialize(object)
    @object = object
  end

  begin
    require './lib/deployed_version'
  rescue LoadError
      module Deployed
        VERSION_ID = 'LOCAL'
        VERSION_STRING = "Sample Management Workflow Lims LOCAL [#{ENV['RACK_ENV']}]"
      end
  end

  def version_information
    # Provides a quick means of checking the deployed version
    Deployed::VERSION_STRING
  end

end
