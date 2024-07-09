require './lib/deployed_version'

# module Presenters
  module DeploymentInfo

    def version_information
      # Provides a quick means of checking the deployed version
      Deployed::VERSION_STRING
    end

    def commit_information
      Deployed::VERSION_COMMIT
    end

    def repo_url
      Deployed::REPO_URL
    end

    def host_name
      Deployed::HOSTNAME
    end

    def release_name
      Deployed::RELEASE_NAME
    end
  end
# end