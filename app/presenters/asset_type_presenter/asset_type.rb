# frozen_string_literal: true

module AssetTypePresenter
  # Presenter for showing an asset type
  class AssetType
    include SharedBehaviour
    include DeploymentInfo

    attr_reader :asset_type

    ALPHANUMERIC_REGEX = '^[\w-]+$'
    NUMERIC_REGEX = '^\d+$'

    def initialize(asset_type)
      @asset_type = asset_type
    end

    delegate :name, to: :asset_type

    def identifier
      asset_type.identifier_type
    end

    def sample_count?
      yield if asset_type.has_sample_count
    end

    delegate :id, to: :asset_type

    def type
      asset_type.labware_type
    end

    def template_name
      asset_type.name.downcase.tr(' ', '_')
    end

    def validates_with
      {
        'alphanumeric' => ALPHANUMERIC_REGEX,
        'numeric' => NUMERIC_REGEX
      }[asset_type.identifier_data_type]
    end

    def asset_fields
      sample_count = asset_type.has_sample_count ? :sample_count : nil
      [:batch_id, :identifier, :study, :project, sample_count, :workflow, :pipeline_destination, :cost_code,
       :created_at, :completed_at].compact
    end

    def field_value_shared_inside_batch?(asset_field)
      %i[batch_id workflow cost_code study project].include?(asset_field)
    end
  end
end
