class Presenter

  module DeploymentInfo

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
  include DeploymentInfo

  module SharedBehaviour

    require './app/models/asset_type'
    require './app/models/workflow'

    def each_asset_type
      AssetType.all.each do |asset_type|
        yield(asset_type.name,asset_type.identifier_type,asset_type.has_sample_count,asset_type.id)
      end
    end
    
    def each_workflow
      Workflow.all.each do |workflow|
        yield(workflow.name,workflow.has_comment,workflow.id)
      end
    end

  end
  include SharedBehaviour

end
