require './app/presenters/presenter'
require './app/presenters/asset/asset'

module Presenter::AssetPresenter
  class Index < Presenter

    attr_reader :search, :assets, :total, :state, :team

    def initialize(found_assets, search=nil, state=nil, team=nil)
      @assets = found_assets.group_by {|a| a.asset_type.name}.tap {|h| h.default = [] }
      @total  = found_assets.length
      @search = search
      @state  = state
      @team = team
    end

    def asset_identifiers
      assets.values.flatten.map(&:identifier)
    end

    def has_assets?(type)
      return assets[type].length > 0
    end

    def num_assets(type)
      return assets[type].length
    end

    def assets_from_batch(type, batch_id)
      assets[type].select{|a| a.batch.id==batch_id}
    end

    def each_asset(type)
      if assets[type].nil?
        return
      end
      assets[type].each do |asset|
        yield Presenter::AssetPresenter::Asset.new(asset)
      end
    end

    def search_parameters
      yield search if is_search?
    end

    def is_search?
      search.present?
    end

    def workflow
      'None'
    end

    def team_id
      team.id if team.present?
    end

    def state_name
      state.name if state.present?
    end

    def humanized_state
      state_name.humanize
    end

    def action_button
      if team.present?
        procedure = team.procedure_for(state)
        if procedure.present?
          procedure.final_state ? "Mark selected assets as #{procedure.final_state.name}" : "Mark selected assets as #{humanized_state}ed"
        end
      end
    end

  end
end
