require './app/presenters/presenter'

module Presenter::AssetTypePresenter
  class AssetType < Presenter

    attr_reader :asset_type

    def initialize(asset_type)
      @asset_type = asset_type
    end

    def name
      asset_type.name
    end

    def identifier
      asset_type.identifier_type
    end

    def sample_count?
      yield if asset_type.has_sample_count
    end

    def id
      asset_type.id
    end

    def type
      asset_type.name.split.first
    end

    def template_name
      asset_type.name.downcase.gsub(' ','_')
    end

    def validates_with
      {
        'alphanumeric' => '^\w+$',
        'numeric'      => '^\d+$'
      }[asset_type.identifier_data_type]
    end

    def asset_fields
      sample_count = asset_type.has_sample_count ? :sample_count : nil
      [:batch_id, :identifier, :study, sample_count, :workflow, :pipeline_destination, :cost_code, :created_at, :completed_at].compact
    end

    def is_field_value_shared_inside_batch?(asset_field)
      [:batch_id, :workflow, :cost_code, :study].include?(asset_field)
    end

  end
end
